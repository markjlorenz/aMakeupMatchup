//
//  DBDTwitterSearchTableCell.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 8-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DBDTwitterSearchTableCell : UITableViewCell {
	IBOutlet UIImageView *iconView;
	IBOutlet UILabel *usernamelabel;
	IBOutlet UILabel *datelabel;
	IBOutlet UITextView *textview;
}

@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *usernamelabel;
@property (nonatomic, retain) UILabel *datelabel;
@property (nonatomic, retain) UITextView *textview;

@end
