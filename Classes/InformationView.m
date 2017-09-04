//
// Created by David Lawson on 14/05/2014.
// Copyright (c) 2014 Livestock Exchange. All rights reserved.
//

#import "InformationView.h"
#import "Informative.h"

@implementation InformationView

- (id)init
{
    self = [super init];
    if (self)
    {
        // Frame will be set in UINavigationController+Informative
        self.frame = CGRectMake(0, -40, 0, 20);

        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];

        UILabel *textLabel = self.textLabel;
        [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        // align textLabel from the left and right
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[textLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];
        // align textLabel from the top and bottom
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[textLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];


        self.alpha = 0.0f;

        [self setDefaults];
    }

    return self;
}

// Set the autoresize mask after the screen rotation has been applied
- (void)didMoveToWindow
{
    [super didMoveToWindow];

    // We can't use autolayout as the superview is the UINavigationBar
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)setDefaults
{
    self.backgroundColor = [UIColor colorWithRed:83.0f/255.0f green:215.0f/255.0f blue:105.0f/255.0f alpha:1.0];
    self.text = @"Information View";
    self.font = [UIFont systemFontOfSize:14];
    self.textColor = [UIColor whiteColor];
}

- (void)startAnimation
{
    CAKeyframeAnimation *blinkAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    blinkAnim.duration = 1.8;
    blinkAnim.autoreverses = false;
    blinkAnim.fillMode = kCAFillModeForwards;
    blinkAnim.repeatCount = HUGE_VALF;
    blinkAnim.keyTimes = @[ @0.0f, @0.1f, @0.5f, @0.9f, @1.0f ];
    blinkAnim.values = @[ @1.0f, @1.0f, @0.0f, @1.0f, @1.0f ];
    blinkAnim.removedOnCompletion = NO;
    
    [_textLabel.layer addAnimation:blinkAnim forKey:@"opacity"];
}

- (void)stopAnimation
{
    [_textLabel.layer removeAllAnimations];
}

- (void)showView:(BOOL)animated
{
    void (^animateTo)() = ^{
        self.frame = CGRectMake(0, -20, self.bounds.size.width, 40);
        self.alpha = 1.0f;
        [self startAnimation];
    };

    if (animated)
    {
        self.frame = CGRectMake(0, -40, self.bounds.size.width, 20);
        self.alpha = 0.0f;

        [UIView animateWithDuration:[Informative singleton].animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:animateTo
                         completion:nil];
    }
    else
    {
        animateTo();
    }
}

- (void)hideView:(BOOL)animated
{
    void (^animateTo)() = ^{
        self.frame = CGRectMake(0, -40, self.bounds.size.width, 20);
        self.alpha = 0.0f;
        [self stopAnimation];
    };

    if (animated)
    {
        [UIView animateWithDuration:[Informative singleton].animationDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:animateTo
                         completion:nil];
    }
    else
    {
        animateTo();
    }
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    self.textLabel.font = font;
}

@end
