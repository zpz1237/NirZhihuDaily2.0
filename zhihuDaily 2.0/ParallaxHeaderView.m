//
//  ParallaxHeaderView.m
//  ParallaxTableViewHeader
//
//  Created by Vinodh  on 26/10/14.
//  Copyright (c) 2014 Daston~Rhadnojnainva. All rights reserved.

//

#import "ParallaxHeaderView.h"
#import "myUILabel.h"

@interface ParallaxHeaderView ()
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIView *subView;
@end

@implementation ParallaxHeaderView

+ (id)parallaxHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
{
    //根据传入的参数确定frame
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    
    //初始化设置并返回
    [headerView initialSetupForCustomSubView:subView];
    return headerView;
}

+ (id)parallaxWebHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
{
    //根据传入的参数确定frame
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, -20, headerSize.width, headerSize.height)];
    
    //初始化设置并返回
    [headerView initialSetupForCustomSubView:subView];
    return headerView;
}

+ (id)parallaxThemeHeaderViewWithSubView:(UIView *)subView forSize:(CGSize)headerSize;
{
    //根据传入的参数确定frame
    ParallaxHeaderView *headerView = [[ParallaxHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    
    //初始化设置并返回
    [headerView initialSetupForCustomSubView:subView];
    return headerView;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
//    CGRect frame = self.imageScrollView.frame;
    
    if (NO)
    {
        //另一种效果 此处用不到
//        frame.origin.y = MAX(offset.y *0.5, 0);
//        self.imageScrollView.frame = frame;
//        self.clipsToBounds = YES;
    }
    else if (offset.y < -154) {
        //只是留个位置供接触到父ViewController的方法
        [self.delegate lockDirection];
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

        delta = offset.y;
        rect.origin.y += delta;
        rect.size.height -= delta;
        
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
    }
    
}

- (void)layoutWebHeaderViewForScrollViewOffset:(CGPoint)offset
{
//    CGRect frame = self.imageScrollView.frame;
    
    if (offset.y > 0)
    {

    }
    else if (offset.y < -85) {
        //只是留个位置供接触到父ViewController的方法
        [self.delegate lockDirection];
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        delta = offset.y;
        rect.origin.y += delta;
        rect.size.height -= delta;
        
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
    }
    
}

- (void)layoutThemeHeaderViewForScrollViewOffset:(CGPoint)offset;
{
    CGRect frame = self.imageScrollView.frame;
    if (offset.y > 0)
    {
        frame.origin.y = offset.y;
        self.imageScrollView.frame = frame;
        self.clipsToBounds = NO;
    }
    else if (offset.y < -95) {
        [self.delegate lockDirection];
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        delta = offset.y;
        rect.origin.y += delta;
        rect.size.height -= delta;
        
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
    }
}

- (void)initialSetupForCustomSubView:(UIView *)subView
{
    //初始化中间层imageScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor yellowColor];
    self.imageScrollView = scrollView;
    
    //设置内容层的自动布局并存储
    subView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.subView = subView;
    
    //将内容层View添加到scrollView上
    [self.imageScrollView addSubview:subView];
    
    [self addSubview:self.imageScrollView];
}

@end
