//
//  aMMAllMatchingOptionsCell.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMAllMatchingOptionsCell.h"
#import "DBDUIViewTools.h"

@implementation aMMAllMatchingOptionsCell
@synthesize iconView;
@synthesize product;
@synthesize brand;
@synthesize formula;
@synthesize color;

- (void)dealloc {
	[iconView release];
	[product release];
	[brand release];
	[formula release];
	[color release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		[self setFrameHeight:81.0];
		self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, self.bounds.size.height)];
		CGFloat textLabelOriginX = iconView.frame.origin.x+iconView.bounds.size.width;
		CGFloat textLabelHeight = 21.0;
		CGFloat textLabelWidth = self.bounds.size.width-textLabelOriginX;
		
		self.product = [[UILabel alloc] initWithFrame:CGRectMake(textLabelOriginX, 0.0, self.bounds.size.width-textLabelOriginX, textLabelHeight)];
		self.brand = [[UILabel alloc] initWithFrame:CGRectMake(textLabelOriginX, product.bounds.size.height+product.frame.origin.y, textLabelWidth, textLabelHeight)];
		self.formula = [[UILabel alloc] initWithFrame:CGRectMake(textLabelOriginX, brand.bounds.size.height+brand.frame.origin.y, textLabelWidth, textLabelHeight)];
		self.color = [[UILabel alloc] initWithFrame:CGRectMake(textLabelOriginX, formula.bounds.size.height+formula.frame.origin.y, textLabelWidth, textLabelHeight)];
		
		product.backgroundColor = [UIColor clearColor];
		brand.backgroundColor = [UIColor clearColor];
		formula.backgroundColor = [UIColor clearColor];
		color.backgroundColor = [UIColor clearColor];
		
		product.font = [UIFont boldSystemFontOfSize:17.0];
		
		product.textColor = [UIColor whiteColor];
		brand.textColor = [UIColor whiteColor];
		formula.textColor = [UIColor lightGrayColor];
		color.textColor	= [UIColor lightGrayColor];
		
		[self addSubview:iconView];
		[self addSubview:product];
		[self addSubview:brand];
		[self addSubview:formula];
		[self addSubview:color];
		
		[iconView release];
		[product release];
		[brand release];
		[formula release];
		[color release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
