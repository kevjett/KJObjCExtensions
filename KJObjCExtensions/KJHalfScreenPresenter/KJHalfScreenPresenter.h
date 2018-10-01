//
//  CustomPresentationController.h
//  CatchUp
//
//  Created by Kevin Jett on 9/18/18.
//  Copyright © 2018 Kevin Jett. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KJHalfScreenPresenterAnimationBottomToHalf,
    KJHalfScreenPresenterAnimationFadeIn
} KJHalfScreenPresenterAnimation;

@interface KJHalfScreenPresenter : NSObject

+ (id)initWithPresentViewController:(UIViewController *)presentedViewController
                 fromViewController:(UIViewController *)presentingViewController;

+ (id)initWithPresentViewController:(UIViewController *)presentedViewController
         fromViewController:(UIViewController *)presentingViewController
      presentationAnimation:(KJHalfScreenPresenterAnimation)animation;

- (void)presentViewController:(UIViewController *)presentedViewController
           fromViewController:(UIViewController *)presentingViewController
        presentationAnimation:(KJHalfScreenPresenterAnimation)animation;

- (void)presentViewController:(UIViewController *)presentedViewController
           fromViewController:(UIViewController *)presentingViewController
        presentationAnimation:(KJHalfScreenPresenterAnimation)animation
                     duration:(CGFloat)duration;

@end
