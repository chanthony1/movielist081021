//
//  PageResult.m
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import "PageResult.h"
#import "Movie.h"

@implementation PageResult

-(instancetype)initWithJsonDictionary:(NSDictionary*) dictionary {
    self = [super init];
    
    if (self) {
        self.page = [[dictionary valueForKey:@"page"] integerValue];
        self.totalResult = [[dictionary valueForKey:@"total_results"] integerValue];
        self.totalPages = [[dictionary valueForKey:@"total_pages"] integerValue];
        
        NSMutableArray* movies = [[NSMutableArray alloc] init];
        NSArray* jsonMovies = [dictionary objectForKey:@"results"];
        for (NSDictionary* movieDict in jsonMovies) {
            Movie* movie = [[Movie alloc] initFromDictionary:movieDict];
            [movies addObject:movie];
        }
        
        self.movies = [NSArray arrayWithArray:movies];
        
    }
    
    return self;
}

@end
