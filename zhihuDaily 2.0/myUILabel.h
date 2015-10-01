//
//  myUILabel.h
//  zhihuNews
//
//  Created by Nirvana on 8/16/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

#ifndef myUILabel_h
#define myUILabel_h

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface myUILabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end

#endif /* myUILabel_h */
