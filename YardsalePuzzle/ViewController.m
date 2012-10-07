//
//  ViewController.m
//  YardsalePuzzle
//
//  Created by Scott Taylor on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define TILE_COUNT 8

@interface ViewController () {
    NSMutableArray *buttons_;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    buttons_ = [NSMutableArray array];

    [super viewDidLoad];
    [self layoutTiles];
}

- (void) layoutTiles {
    CGFloat xOffset = 0;
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat tileWidth = frameWidth / 3.0f;
    CGFloat tileHeight = frameHeight / 3.0f;
    CGFloat yOffset = -tileHeight;

    for (int i = 0; i < 8; i++) {
        if ((i % 3) == 0) {
            xOffset = 0;
            yOffset += tileHeight;
        } else {
            xOffset += tileWidth;
        }

        NSString *tileImageName = [NSString stringWithFormat: @"yardsale-0%i.png", i + 1];
        UIImage *image = [UIImage imageNamed: tileImageName];

        UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.frame = CGRectMake(xOffset, yOffset, tileWidth, tileHeight);
        [button setImage: image forState:UIControlStateNormal];

        [buttons_ addObject: button];

        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
    }

    [buttons_ addObject: [NSNull null]];
}

- (void) selectButton: (UIButton *) button {
    int buttonIndex = [buttons_ indexOfObject: button];
    int emptyIndex = [buttons_ indexOfObject: [NSNull null]];

    CGFloat buttonWidth = button.frame.size.width;
    CGFloat buttonHeight = button.frame.size.height;
    CGFloat targetXOffset = (emptyIndex % 3) * buttonWidth;
    CGFloat targetYOffset = (emptyIndex / 3) * buttonHeight;
    CGFloat buttonXOffset = (buttonIndex % 3) * buttonWidth;
    CGFloat buttonYOffset = (buttonIndex / 3) * buttonHeight;

    // if it doesn't border it on one side, we can't do anything
    if (targetYOffset == buttonYOffset) {
        if (buttonXOffset + buttonWidth != targetXOffset &&
            buttonXOffset - buttonWidth != targetXOffset &&
            buttonXOffset != targetXOffset) {
                return;
        }
    } else if (targetXOffset == buttonXOffset) {
        if (buttonYOffset + buttonHeight != targetYOffset &&
            buttonYOffset - buttonHeight != targetYOffset &&
            buttonYOffset != targetYOffset) {
                return;
        }
    } else {
        return;
    }

    [buttons_ exchangeObjectAtIndex: buttonIndex withObjectAtIndex: emptyIndex];

    [UIView animateWithDuration:1.0 animations: ^{
        button.frame = CGRectMake(targetXOffset, targetYOffset, buttonWidth, buttonHeight);
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    buttons_ = nil;
}

@end
