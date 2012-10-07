//
//  ViewController.m
//  YardsalePuzzle
//
//  Created by Scott Taylor on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define TILES_PER_ROW 4
#define TILE_COUNT 15

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
    CGFloat tileWidth = frameWidth / TILES_PER_ROW;
    CGFloat tileHeight = frameHeight / TILES_PER_ROW;
    CGFloat yOffset = -tileHeight;

    UIImage *largeImage = [UIImage imageNamed: @"yardsale.jpeg"];

    for (int i = 0; i < TILE_COUNT; i++) {
        if ((i % TILES_PER_ROW) == 0) {
            xOffset = 0;
            yOffset += tileHeight;
        } else {
            xOffset += tileWidth;
        }

        UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.frame = CGRectMake(xOffset, yOffset, tileWidth, tileHeight);

        CGImageRef imageRef = CGImageCreateWithImageInRect([largeImage CGImage], button.frame);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);

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
    CGFloat targetXOffset = (emptyIndex % TILES_PER_ROW) * buttonWidth;
    CGFloat targetYOffset = (emptyIndex / TILES_PER_ROW) * buttonHeight;
    CGFloat buttonXOffset = (buttonIndex % TILES_PER_ROW) * buttonWidth;
    CGFloat buttonYOffset = (buttonIndex / TILES_PER_ROW) * buttonHeight;

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
