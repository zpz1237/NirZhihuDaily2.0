//
//  GradientView.h
//  GradientView
//
//  Created by xun yanan on 14-6-14.
//  Copyright (c) 2014年 xun yanan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TRANSPARENT_GRADIENT_TYPE 1
#define COLOR_GRADIENT_TYPE 2
#define TRANSPARENT_GRADIENT_TWICE_TYPE 3
#define TRANSPARENT_ANOTHER_GRADIENT_TYPE 4

@interface GradientView : UIView

- (id)initWithFrame:(CGRect)frame type:(int) type;
- (void) insertTwiceTransparentGradient;
- (void) insertTransparentGradient;
@end
