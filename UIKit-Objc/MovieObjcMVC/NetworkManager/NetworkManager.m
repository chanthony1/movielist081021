//
//  NetworkManager.m
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (instancetype) sharedInstance {
    static NetworkManager* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)getMoviesWithPageNumber:(NSInteger)pageNumber completion:(void (^)(PageResult *))completion {
    
    NSString* urlS = [NSString stringWithFormat:@"%@%ld", BASE_MOVIE_URL, (long)pageNumber];
    NSURL* url = [NSURL URLWithString:urlS];
    
    // use URLSession
    [[[NSURLSession sharedSession]
         dataTaskWithURL:url
         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                completion(nil);
                return;
            }
            
            if (data == nil) {
                completion(nil);
                return;
            }
            
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dictionary = object;
                // parse this dictionary into my PageResult model
                PageResult* page = [[PageResult alloc] initWithJsonDictionary:dictionary];
                completion(page);
                return;
            }
            
        }] resume];
    
}

- (void)getImageWithPath:(NSString *)posterPath completion:(void(^)(UIImage *))completion {
    
    NSString* urlS = [NSString stringWithFormat:@"%@%@", BASE_IMAGE_URL, posterPath];
    NSURL* url = [NSURL URLWithString:urlS];
    
    // use URLSession
    [[[NSURLSession sharedSession]
         dataTaskWithURL:url
         completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil);
            return;
        }
            
        if (data == nil) {
            completion(nil);
            return;
        }
        
        // have data here
        UIImage* image = [UIImage imageWithData:data];
        completion(image);
        
        }] resume];
}

@end
