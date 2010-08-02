//
//  aMMAllMatchingOptionsCell.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface aMMAllMatchingOptionsCell : UITableViewCell {
	IBOutlet UIImageView *iconView;
	IBOutlet UILabel *product;
	IBOutlet UILabel *brand;
	IBOutlet UILabel *formula;
	IBOutlet UILabel *color;	
}
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *product;
@property (nonatomic, retain) UILabel *brand;
@property (nonatomic, retain) UILabel *formula;
@property (nonatomic, retain) UILabel *color;

@end
