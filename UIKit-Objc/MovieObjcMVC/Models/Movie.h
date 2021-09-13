//
//  Movie.h
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) NSString* posterImage;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) double rating;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString* releaseDate;
@property (nonatomic, copy) NSString* overView;

- (instancetype)initFromDictionary:(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
