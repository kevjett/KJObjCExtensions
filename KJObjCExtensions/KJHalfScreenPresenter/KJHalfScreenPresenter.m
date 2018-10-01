

/**
 * Presents a view controller modally by superposing it's view on top of the
 * presenting's view, but retaining it's context.
 *
 * Useful for creating a modal presentation with a dimmed background.
 */

#import "KJHalfScreenPresenter.h"
#import "KJTapGestureRecognizer.h"

static const CGFloat KJHalfScreenPresenterAnimationDuration = 0.25f;

@interface KJHalfScreenPresenter () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) BOOL isPresenting;
@property (assign, nonatomic) KJHalfScreenPresenterAnimation animation;
@property (assign, nonatomic) CGFloat duration;

@end

@implementation KJHalfScreenPresenter

- (instancetype)init
{
    if (self = [super init]) {
        self.duration = KJHalfScreenPresenterAnimationDuration;
    }
    
    return self;
}

+ (id)initWithPresentViewController:(UIViewController *)presentedViewController
                 fromViewController:(UIViewController *)presentingViewController {
    
    KJHalfScreenPresenter *control = [KJHalfScreenPresenter new];
    [control presentViewController:presentedViewController fromViewController:presentingViewController presentationAnimation:KJHalfScreenPresenterAnimationBottomToHalf];
    return control;
}

+ (id)initWithPresentViewController:(UIViewController *)presentedViewController
         fromViewController:(UIViewController *)presentingViewController
      presentationAnimation:(KJHalfScreenPresenterAnimation)animation {
    
    KJHalfScreenPresenter *control = [KJHalfScreenPresenter new];
    [control presentViewController:presentedViewController fromViewController:presentingViewController presentationAnimation:animation];
    return control;
}

- (void)presentViewController:(UIViewController *)presentedViewController
           fromViewController:(UIViewController *)presentingViewController
        presentationAnimation:(KJHalfScreenPresenterAnimation)animation
{
    
    
    self.animation = animation;
    presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    presentedViewController.transitioningDelegate = self;
    presentedViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [presentedViewController setNeedsStatusBarAppearanceUpdate];
    
    //this means the same controller is already pushed, lets skip this call then
    if ([presentingViewController.presentedViewController isKindOfClass:presentedViewController.class]) {
        return;
    }
    [presentingViewController presentViewController:presentedViewController
                                           animated:YES
                                         completion:nil];
}

- (void)presentViewController:(UIViewController *)presentedViewController
           fromViewController:(UIViewController *)presentingViewController
        presentationAnimation:(KJHalfScreenPresenterAnimation)animation
                     duration:(CGFloat)duration
{
    self.duration = duration;
    
    [self presentViewController:presentedViewController
             fromViewController:presentingViewController
          presentationAnimation:animation];
}

#pragma mark - UIViewController transition delegate

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForPresentedController:(UIViewController *)presented

                                                                    presentingController:(UIViewController *)presenting
                                                                        sourceController:(UIViewController *)source
{
    self.isPresenting = YES;
    
    return self;
}

- (id <UIViewControllerAnimatedTransitioning> )animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresenting = NO;
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning protocol

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning> )transitionContext
{
    return KJHalfScreenPresenterAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning> )transitionContext
{
    UIViewController *firstVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *secondVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIView *firstView = firstVC.view;
    UIView *secondView = secondVC.view;
    
    BOOL isBottomToTopAnimation = self.animation == KJHalfScreenPresenterAnimationBottomToHalf;
    
    if (self.isPresenting) {
        UIView *dimmedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height)];
        dimmedView.backgroundColor = [UIColor blackColor];
        dimmedView.alpha = 0;
        dimmedView.userInteractionEnabled = YES;
        [containerView addSubview:dimmedView];
        
        KJTapGestureRecognizer *closeGesture = [[KJTapGestureRecognizer alloc] initWithTarget:[KJHalfScreenPresenter class] action:@selector(closeAction:)];
        closeGesture.viewController = secondVC;
        [dimmedView addGestureRecognizer:closeGesture];
        
        [containerView addSubview:secondView];
        secondView.frame = (CGRect) {
            containerView.frame.origin.x,
            isBottomToTopAnimation ? containerView.frame.origin.y + containerView.frame.size.height : containerView.frame.origin.y,
            containerView.frame.size
        };
        
        secondView.alpha = isBottomToTopAnimation ? 1.f : 0.f;
        
        [UIView animateWithDuration:KJHalfScreenPresenterAnimationDuration
                         animations: ^{
                             if (isBottomToTopAnimation) {
                                 //secondView.frame = containerView.frame;
                                 secondView.frame = (CGRect) {
                                     containerView.frame.origin.x,
                                     containerView.frame.size.height/2,
                                     containerView.frame.size.width,
                                     containerView.frame.size.height/2
                                 };
                                 dimmedView.alpha = 0.6f;
                             }
                             else {
                                 secondView.alpha = 1.f;
                             }
                         } completion: ^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        [UIView animateWithDuration:KJHalfScreenPresenterAnimationDuration
                         animations: ^{
                             if (isBottomToTopAnimation) {
                                 firstView.frame = (CGRect) {
                                     containerView.frame.origin.x,
                                     containerView.frame.origin.y + containerView.frame.size.height,
                                     containerView.frame.size
                                 };
                                 firstView.alpha = 1.f;
                             }
                             else {
                                 firstView.alpha = 0.f;
                             }
                         } completion: ^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
}

+(void)closeAction:(KJTapGestureRecognizer *)tapRecognizer {
    [tapRecognizer.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
