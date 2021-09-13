//
//  MovieCell.m
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import "MovieCell.h"

@implementation MovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    
    UIImageView* poster = [[UIImageView alloc] initWithFrame:CGRectZero];
    poster.translatesAutoresizingMaskIntoConstraints = false;
    [poster setContentMode:UIViewContentModeScaleAspectFit];
    [poster setImage:[UIImage imageNamed:@"question-mark"]];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = false;
    [label setNumberOfLines:0];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:@"Text goes here"];
    
    [self.contentView addSubview:poster];
    [self.contentView addSubview:label];
    
    // constraints
    [[poster.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8] setActive:true];
    [[poster.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8] setActive:true];
    [[poster.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8] setActive:true];
    [[poster.heightAnchor constraintEqualToConstant:100] setActive:true];
    [[poster.widthAnchor constraintEqualToConstant:100] setActive:true];
    
    [[label.leadingAnchor constraintEqualToAnchor:poster.trailingAnchor constant:8] setActive:true];
    [[label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8] setActive:true];
    [[label.centerYAnchor constraintEqualToAnchor:poster.centerYAnchor] setActive:true];
    
    self.posterView = poster;
    self.titleLabel = label;
}

@end
