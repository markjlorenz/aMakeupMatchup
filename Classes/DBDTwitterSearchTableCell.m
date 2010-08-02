//
//  DBDTwitterSearchTableCell.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 8-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDTwitterSearchTableCell.h"


@implementation DBDTwitterSearchTableCell
@synthesize iconView;
@synthesize usernamelabel;
@synthesize datelabel;
@synthesize textview;

- (void)dealloc {
	[iconView release];
	[usernamelabel release];
	[datelabel release];
	[textview release];
    
	[super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
		CGFloat textLabelOriginX = iconView.frame.origin.x+iconView.bounds.size.width + 5.0;
		CGFloat textLabelHeight = 15.0;
		CGFloat textLabelWidth = self.bounds.size.width-textLabelOriginX;
		
		self.usernamelabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabelOriginX, 5.0, self.bounds.size.width-textLabelOriginX, textLabelHeight)];
		self.datelabel = [[UILabel alloc] initWithFrame:CGRectMake((int)(self.bounds.size.width - ((self.bounds.size.width-textLabelOriginX)/2))-5, 5.0, (int)((self.bounds.size.width-textLabelOriginX)/2), textLabelHeight)];
		self.textview = [[UITextView alloc] initWithFrame:CGRectMake(textLabelOriginX, usernamelabel.bounds.size.height, textLabelWidth, self.bounds.size.height-textLabelHeight - usernamelabel.frame.origin.y)];
		textview.userInteractionEnabled = NO;
		textview.editable = NO;
		
		usernamelabel.backgroundColor = [UIColor clearColor];
		datelabel.backgroundColor = [UIColor clearColor];
		textview.backgroundColor = [UIColor clearColor];
		
		usernamelabel.font = [UIFont boldSystemFontOfSize:12.0];
		datelabel.font = [UIFont systemFontOfSize:10.0];
		textview.font = [UIFont systemFontOfSize:12.0];
		
		usernamelabel.textColor = [UIColor whiteColor];
		datelabel.textColor = [UIColor whiteColor];
		textview.textColor = [UIColor whiteColor];
		
		datelabel.textAlignment = UITextAlignmentRight;
		
		[self.contentView addSubview:iconView];
		[self.contentView addSubview:usernamelabel];
		[self.contentView addSubview:datelabel];
		[self.contentView addSubview:textview];
		
		[iconView release];
		[usernamelabel release];
		[datelabel release];
		[textview release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
