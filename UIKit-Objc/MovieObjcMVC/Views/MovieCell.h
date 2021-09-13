//
//  MovieCell.h
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (nonatomic, weak) UIImageView* posterView;
@property (nonatomic, weak) UILabel* titleLabel;

@end

NS_ASSUME_NONNULL_END
