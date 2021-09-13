//
//  NetworkManager.h
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#define BASE_MOVIE_URL @"https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=6622998c4ceac172a976a1136b204df4&page="
#define BASE_IMAGE_URL @"https://image.tmdb.org/t/p/w500/"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PageResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+ (instancetype) sharedInstance;

- (void)getMoviesWithPageNumber:(NSInteger)pageNumber completion:(void (^)(PageResult *))completion;
- (void)getImageWithPath:(NSString *)posterPath completion:(void(^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
