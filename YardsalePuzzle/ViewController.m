//
//  ViewController.m
//  YardsalePuzzle
//
//  Created by Scott Taylor on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#define TILES_PER_ROW 4
#define ROWS 4

@interface ViewController () {
    NSMutableArray *buttons_;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutTiles];
}

- (void) layoutTiles {
    UIImage *largeImage = [UIImage imageNamed: @"yardsale.jpeg"];
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    CGFloat tileWidth = frameWidth / TILES_PER_ROW;
    CGFloat tileHeight = frameHeight / ROWS;
    CGFloat xOffset = 0;
    CGFloat yOffset = 0;

    // 4x4 array
    buttons_ = [NSMutableArray arrayWithCapacity: ROWS];

    for (int i = 0; i < ROWS; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity: TILES_PER_ROW];
        [buttons_ addObject: array];

        for (int j = 0; j < TILES_PER_ROW; j++) {
            if (i == ROWS - 1 && j == TILES_PER_ROW - 1) {
                [array addObject: [NSNull null]];
                continue;
            }

            UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
            button.frame = CGRectMake(xOffset, yOffset, tileWidth, tileHeight);

            CGImageRef imageRef = CGImageCreateWithImageInRect([largeImage CGImage], button.frame);
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);

            [button setImage: image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview: button];

            [array addObject: button];

            xOffset += tileWidth;
        }

        xOffset = 0;
        yOffset += tileHeight;
    }
}

- (void) selectButton: (UIButton *) button {
    int emptyXIndex = 0;
    int emptyYIndex = 0;
    int buttonXIndex = 0;
    int buttonYIndex = 0;

    // find the empty one
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < TILES_PER_ROW; j++) {
            UIButton *b = [[buttons_ objectAtIndex: i] objectAtIndex: j];

            if ((NSNull *) b == [NSNull null]) {
                emptyXIndex = i;
                emptyYIndex = j;
            } else if (b == button) {
                buttonXIndex = i;
                buttonYIndex = j;
            }
        }
    }

    CGFloat buttonWidth = button.frame.size.width;
    CGFloat buttonHeight = button.frame.size.height;

    if (buttonXIndex == emptyXIndex) { // right / left shifts
        NSMutableArray *row = [buttons_ objectAtIndex: buttonXIndex];
        if (emptyYIndex > buttonYIndex) { // right shift
            for (int i = emptyYIndex; i > buttonYIndex; i--) {
                UIButton *b = [row objectAtIndex: i - 1];

                [UIView animateWithDuration:1.0 animations: ^{
                    b.frame = CGRectMake(b.frame.origin.x + buttonWidth, b.frame.origin.y, buttonWidth, buttonHeight);
                }];

                [row exchangeObjectAtIndex: i withObjectAtIndex: i-1];
            }
        } else { // left shift
            for (int i = emptyYIndex; i < buttonYIndex; i++) {
                UIButton *b = [row objectAtIndex: i + 1];

                [UIView animateWithDuration:1.0 animations: ^{
                    b.frame = CGRectMake(b.frame.origin.x - buttonWidth, b.frame.origin.y, buttonWidth, buttonHeight);
                }];

                [row exchangeObjectAtIndex: i withObjectAtIndex: i+1];
            }
        }
    } else if (buttonYIndex == emptyYIndex) { // up / down shifts
        if (emptyXIndex > buttonXIndex) { // down
            for (int i = emptyXIndex; i > buttonXIndex; i--) {
                UIButton *b = [[buttons_ objectAtIndex: i - 1] objectAtIndex: buttonYIndex];

                [UIView animateWithDuration:1.0 animations: ^{
                    b.frame = CGRectMake(b.frame.origin.x, b.frame.origin.y + buttonHeight, buttonWidth, buttonHeight);
                }];

                [[buttons_ objectAtIndex: i] replaceObjectAtIndex: buttonYIndex withObject: b];
                [[buttons_ objectAtIndex: i - 1] replaceObjectAtIndex: buttonYIndex withObject: [NSNull null]];
            }
        } else {
            for (int i = emptyXIndex; i < buttonXIndex; i++) { // up
                UIButton *b = [[buttons_ objectAtIndex: i + 1] objectAtIndex: buttonYIndex];

                [UIView animateWithDuration:1.0 animations: ^{
                    b.frame = CGRectMake(b.frame.origin.x, b.frame.origin.y - buttonHeight, buttonWidth, buttonHeight);
                }];

                [[buttons_ objectAtIndex: i] replaceObjectAtIndex: buttonYIndex withObject: b];
                [[buttons_ objectAtIndex: i + 1] replaceObjectAtIndex: buttonYIndex withObject: [NSNull null]];
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    buttons_ = nil;
}

@end
