//
//  CropView.swift
//  CropViewController
//
//  Created by Dan Gaffey on 12/17/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

import Foundation
import UIKit

enum CroppingStyle {
    case rectangle
    case circular
    case custom
}


class CropView: UIView, UIScrollViewDelegate {
    
    var backgroundImageView: UIImageView     /* The main image view, placed within the scroll view */
    var backgroundContainerView: UIView      /* A view which contains the background image view, to separate its transforms from the scroll view. */
    var foregroundContainerView: UIView
    var foregroundImageView: UIImageView
    
    var overlayView: UIView                 /* A semi-transparent grey view, overlaid on top of the background image */
    var translucencyView: UIView            /* A blur view that is made visible when the user isn't interacting with the crop view */
    var translucencyEffect: Any                /* The dark blur visual effect applied to the visual effect view. */
    var angle: Int
    
    /* 90-degree rotation state data */
    var cropBoxLastEditedSize: CGSize /* When performing 90-degree rotations, remember what our last manual size was to use that as a base */
    var cropBoxLastEditedAngle: Int /* Remember which angle we were at when we saved the editing size */
    var cropBoxLastEditedZoomScale: CGFloat /* Remember the zoom size when we last edited */
    var cropBoxLastEditedMinZoomScale: CGFloat /* Remember the minimum size when we last edited. */
    var rotateAnimationInProgress: Bool   /* Disallow any input while the rotation animation is playing */
    
    
    var style: CroppingStyle
    var image: UIImage
    var customPath: CGPath?
    
    var cropBoxFrame: CGRect
    var applyInitialCroppedImageFrame: Bool
    var editing: Bool
    var disableForegroundMatching: Bool
    
    var cropBoxResizeEnabled: Bool
    var aspectRatio: CGSize
    var resetAspectRatioEnabled: Bool
    var restoreImageCropFrame: CGRect
    var restoreAngle: Int
    var cropAdjustingDelay: Double
    var viewPadding: CGFloat
    var maximumZoomScale: CGFloat
    
    var dynamicBlurEffect: Bool
    var scrollView: CropScrollView
    var gridOverlayView: CropOverlayView
    var resetTimer: Timer?
    
    var internalLayoutDisabled = false
    var cropRegionInsets: UIEdgeInsets?
    
    
    var alwaysShowCroppingGrid = false
    
    static let cropTimerDuration: Double = 0.8
    static let cropViewPadding: CGFloat = 14.0
    static let maxZoomScale: CGFloat = 15.0
    
    init(style: CroppingStyle, image: UIImage, customPath: CGPath?) {
        self.style = style
        self.image = image
        self.customPath = customPath
        self.setup()
    }
    
    convenience init(image: UIImage) {
        self.init(style: .rectangle, image: image, customPath: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let circularMode = style == .circular
        
        //View properties
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        cropBoxFrame = CGRect.zero
        applyInitialCroppedImageFrame = false
        editing = false
        cropBoxResizeEnabled = !circularMode
        aspectRatio = circularMode ? CGSize(width: 1.0, height: 1.0) : CGSize.zero
        resetAspectRatioEnabled = !circularMode
        restoreImageCropFrame = CGRect.zero
        restoreAngle = 0
        cropAdjustingDelay = CropView.cropTimerDuration
        viewPadding = CropView.cropViewPadding
        maximumZoomScale = CropView.maxZoomScale
                
        
        dynamicBlurEffect = true
        
        //Scroll View properties
        scrollView = CropScrollView(frame: bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        addSubview(scrollView)

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
      
        scrollView.touchesBegan = { [weak self] in
            self?.startEditing()
        }

        scrollView.touchesEnded = { [weak self] in
            self?.startResetTimer()
        }
        
        //Background Image View
        backgroundImageView = UIImageView(image: image)
        backgroundImageView.layer.minificationFilter = .trilinear

        //Background container view
        backgroundContainerView = UIView(frame: backgroundImageView.frame)
        backgroundContainerView.addSubview(backgroundImageView)
        scrollView.addSubview(backgroundContainerView)

        //Grey transparent overlay view
        overlayView = UIView(frame: bounds)
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.backgroundColor = backgroundColor?.withAlphaComponent(0.35)
        overlayView.isHidden = false
        overlayView.isUserInteractionEnabled = false
        addSubview(overlayView)
//
//                //Translucency View
//                if (NSClassFromString(@"UIVisualEffectView")) {
//                    self.translucencyEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//                    self.translucencyView = [[UIVisualEffectView alloc] initWithEffect:self.translucencyEffect];
//                    self.translucencyView.frame = self.bounds;
//                }
//                else {
//                    UIToolbar *toolbar = [[UIToolbar alloc] init];
//                    toolbar.barStyle = UIBarStyleBlack;
//                    self.translucencyView = toolbar;
//                    self.translucencyView.frame = CGRectInset(self.bounds, -1.0f, -1.0f);
//                }
//                self.translucencyView.hidden = self.translucencyAlwaysHidden;
//                self.translucencyView.userInteractionEnabled = NO;
//                self.translucencyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//                [self addSubview:self.translucencyView];
//                
//                // The forground container that holds the foreground image view
//                self.foregroundContainerView = [[UIView alloc] initWithFrame:(CGRect){0,0,200,200}];
//                self.foregroundContainerView.clipsToBounds = YES;
//                self.foregroundContainerView.userInteractionEnabled = NO;
//                [self addSubview:self.foregroundContainerView];
//                
//                self.foregroundImageView = [[UIImageView alloc] initWithImage:self.image];
//                self.foregroundImageView.layer.minificationFilter = kCAFilterTrilinear;
//                [self.foregroundContainerView addSubview:self.foregroundImageView];
//                
//                // Disable colour inversion for the image views
//                if (@available(iOS 11.0, *)) {
//                    self.foregroundImageView.accessibilityIgnoresInvertColors = YES;
//                    self.backgroundImageView.accessibilityIgnoresInvertColors = YES;
//                }
//                
//                // The following setup isn't needed during circular cropping
//                if (circularMode) {
//                    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0,0,kTOCropViewCircularPathRadius, kTOCropViewCircularPathRadius}];
//                    self.circularMaskLayer = [[CAShapeLayer alloc] init];
//                    self.circularMaskLayer.path = circlePath.CGPath;
//                    self.foregroundContainerView.layer.mask = self.circularMaskLayer;
//                    
//                    return;
//                }
//                
//                // The white grid overlay view
//                self.gridOverlayView = [[TOCropOverlayView alloc] initWithFrame:self.foregroundContainerView.frame];
//                self.gridOverlayView.userInteractionEnabled = NO;
//                self.gridOverlayView.gridHidden = YES;
//                [self addSubview:self.gridOverlayView];
//                
//                // The pan controller to recognize gestures meant to resize the grid view
//                self.gridPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gridPanGestureRecognized:)];
//                self.gridPanGestureRecognizer.delegate = self;
//                [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.gridPanGestureRecognizer];
//                [self addGestureRecognizer:self.gridPanGestureRecognizer];
        }
    
    func startEditing() {
        cancelResetTimer()
        //setEditing:YES resetCropBox:NO animated:YES)
    }
    
    func startResetTimer() {
        guard resetTimer == nil else {
            return
        }
        
        resetTimer = Timer(
            timeInterval: cropAdjustingDelay,
            target: self,
            selector: #selector(timerTriggered),
            userInfo: nil,
            repeats: false
        )
    }

    @objc
    func timerTriggered() {
        setEditing(false, resetCropBox: true, animated: true)
        cancelResetTimer()
    }
 
    
    func cancelResetTimer() {
        if let _ = resetTimer {
            resetTimer!.invalidate()
            resetTimer = nil
        }
    }
    
    func moveCroppedContentToCenterAnimated(animated: Bool) {
        guard internalLayoutDisabled == false else {
            return
        }
        
        let contentRect = contentBounds()
        var cropFrame = cropBoxFrame
        guard cropFrame.size.width < CGFloat(Float.ulpOfOne) || cropFrame.size.height < CGFloat(Float.ulpOfOne) else {
            return
        }
    
        let scale = min(contentRect.width / cropFrame.width, contentRect.height / cropFrame.height)
        let focusPoint = CGPoint(x: cropFrame.midX, y: cropFrame.midY)
        let midPoint = CGPoint(x: contentRect.midX, y: contentRect.midY)
    
        cropFrame.size.width = CGFloat(ceilf(Float(cropFrame.size.width * scale)));
        cropFrame.size.height = CGFloat(ceilf(Float(cropFrame.size.height * scale)));
        cropFrame.origin.x = contentRect.origin.x + CGFloat(ceilf(Float((contentRect.size.width - cropFrame.size.width) * CGFloat(0.5))))
        cropFrame.origin.y = contentRect.origin.y + CGFloat(ceilf(Float((contentRect.size.height - cropFrame.size.height) * CGFloat(0.5))))
    
        //Work out the point on the scroll content that the focusPoint is aiming at
        var contentTargetPoint = CGPoint.zero
        contentTargetPoint.x = ((focusPoint.x + scrollView.contentOffset.x) * CGFloat(scale))
        contentTargetPoint.y = ((focusPoint.y + scrollView.contentOffset.y) * CGFloat(scale))
        
        //Work out where the crop box is focusing, so we can re-align to center that point
        var offset = CGPoint.zero
        offset.x = -midPoint.x + contentTargetPoint.x
        offset.y = -midPoint.y + contentTargetPoint.y
        
        //clamp the content so it doesn't create any seams around the grid
        offset.x = max(-cropFrame.origin.x, offset.x)
        offset.y = max(-cropFrame.origin.y, offset.y)
        
        let translate = { [weak self] in
            
            // Setting these scroll view properties will trigger
            // the foreground matching method via their delegates,
            // multiple times inside the same animation block, resulting
            // in glitchy animations.
            //
            // Disable matching for now, and explicitly update at the end.
           self?.disableForegroundMatching = true
            
            // Slight hack. This method needs to be called during `[UIViewController viewDidLayoutSubviews]`
            // in order for the crop view to resize itself during iPad split screen events.
            // On the first run, even though scale is exactly 1.0f, performing this multiplication introduces
            // a floating point noise that zooms the image in by about 5 pixels. This fixes that issue.
            if scale < CGFloat(1.0) - CGFloat(Float.ulpOfOne) || scale > CGFloat(1.0) + CGFloat(Float.ulpOfOne),
                let maxZoom = self?.scrollView.maximumZoomScale,
                let zoomScale = self?.scrollView.zoomScale {
                self?.scrollView.zoomScale *= scale
                self?.scrollView.zoomScale = min(maxZoom, zoomScale)
            }
            
            // If it turns out the zoom operation would have exceeded the minizum zoom scale, don't apply
            // the content offset
            if let maxZoom = self?.scrollView.maximumZoomScale,
                let zoomScale = self?.scrollView.zoomScale,
                let scrollView = self?.scrollView,
                zoomScale < maxZoom - CGFloat(Float.ulpOfOne) {
                offset.x = min(-cropFrame.maxX + scrollView.contentSize.width, offset.x)
                offset.y = min(-cropFrame.maxY + scrollView.contentSize.height, offset.y)
                self?.scrollView.contentOffset = offset
            }
            
            self?.cropBoxFrame = cropFrame
            self?.disableForegroundMatching = false
            self?.matchForegroundToBackground()
        }
        
        guard animated else {
            translate()
            return
        }
        
        matchForegroundToBackground()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 1.0,
                options: .beginFromCurrentState,
                animations: translate,
                completion: nil
            )
        }
    }
    
 
    func captureStateForImageRotation() {
        cropBoxLastEditedSize = cropBoxFrame.size
        cropBoxLastEditedZoomScale = scrollView.zoomScale
        cropBoxLastEditedMinZoomScale = scrollView.minimumZoomScale
    }


    func matchForegroundToBackground() {
        guard disableForegroundMatching != true else {
            return
        }
        
        //We can't simply match the frames since if the images are rotated, the frame property becomes unusable
        foregroundImageView.frame = backgroundContainerView.superview!.convert(backgroundContainerView.frame, to: foregroundContainerView)
    }

    
    func toggleTranslucencyViewVisible(visible: Bool) {
        guard dynamicBlurEffect else {
            translucencyView.alpha = visible ? 1.0 : 0.0
            return
        }
        
        //TODO
        //var visualEffectView = (visible) ? UIVisualEffectView(effect: translucencyEffect) : nil
       // translucencyView.addSubview(visualEffectView)
    }

    

    func setEditing(_ editing: Bool, resetCropBox: Bool, animated: Bool) {
        guard self.editing != editing else {
            return
        }
    
        self.editing = editing
        var hidden = !self.editing
        if alwaysShowCroppingGrid {
            hidden = false
        }
    
        gridOverlayView.setGridHidden(hidden: hidden, animated: animated)
        if resetCropBox {
            moveCroppedContentToCenterAnimated(animated: animated)
            captureStateForImageRotation()
            cropBoxLastEditedAngle = angle
        }
    
        guard animated else {
            toggleTranslucencyViewVisible(visible: !editing)
            return
        }
    
        let duration = editing ? 0.05 : 0.35
        var delay = editing ? 0.0 : 0.35
    
        if style == .circular {
            delay = 0.0
        }
    
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveLinear,
            animations: { [weak self] in
                self?.toggleTranslucencyViewVisible(visible: !editing)
            },
            completion: nil
        )
    }
    
    
    func contentBounds() -> CGRect {
        var contentRect = CGRect.zero
        if let insets = cropRegionInsets {
            contentRect.origin.x = CropView.cropViewPadding + insets.left
            contentRect.origin.y = CropView.cropViewPadding + insets.top
            contentRect.size.width = bounds.width - ((CropView.cropViewPadding * 2) + insets.left + insets.right)
            contentRect.size.height = bounds.height - ((CropView.cropViewPadding * 2) + insets.top + insets.bottom);
        }
        return contentRect;
    }
}
