//
//  Movie.m
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.identifier = [[dictionary valueForKey:@"id"] integerValue];
        self.posterImage = [dictionary valueForKey:@"poster_path"];
        self.title = [dictionary valueForKey:@"title"];
        self.rating = [[dictionary valueForKey:@"vote_average"] doubleValue];
        self.duration = [[dictionary valueForKey:@"runtime"] integerValue];
        self.releaseDate = [dictionary valueForKey:@"release_date"];
        self.overView = [dictionary valueForKey:@"overview"];
    }
    return self;
}

@end
