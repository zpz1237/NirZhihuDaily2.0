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

@interface GradientView : UIView

- (id)initWithFrame:(CGRect)frame type:(int) type;
@end
