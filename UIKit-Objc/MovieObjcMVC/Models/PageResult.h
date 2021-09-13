//
//  PageResult.h
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageResult : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger totalResult;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) NSArray* movies;

-(instancetype)initWithJsonDictionary:(NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
