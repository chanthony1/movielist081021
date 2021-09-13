//
//  ViewController.m
//  MovieObjcMVC
//
//  Created by Christian Quicano on 10/09/21.
//

#import "MoviesListViewController.h"
#import "PageResult.h"
#import "NetworkManager.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieObjcMVC-Swift.h"

@interface MoviesListViewController ()

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) PageResult* currentPage;
@property (nonatomic, strong) NSMutableArray<Movie*>* movies;

- (void)fetchMovies;

@end

@implementation MoviesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUp];
    [self fetchMovies];
    
}

- (void)setUp {
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectZero];
    table.translatesAutoresizingMaskIntoConstraints = false;
    [table setDataSource:self];
    [table setPrefetchDataSource:self];
    [table registerClass:[MovieCell self] forCellReuseIdentifier:@"cellID"];
    [table registerClass:[MovieSwiftCell self] forCellReuseIdentifier:[MovieSwiftCell identifier]];
    self.tableView = table;
    
    [self.view addSubview:self.tableView];
    
    // constraints
    UILayoutGuide* safeArea = self.view.safeAreaLayoutGuide;
    [[table.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:8] setActive:true];
    [[table.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:8] setActive:true];
    [[table.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-8] setActive:true];
    [[table.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-8] setActive:true];
    
    [table setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.movies = [[NSMutableArray alloc] init];
}

- (void)fetchMovies {
    
    // start the call
    NSInteger pageN = 1;
    if (self.currentPage) {
        pageN = self.currentPage.page + 1;
    }
    [[NetworkManager sharedInstance] getMoviesWithPageNumber:pageN completion:^(PageResult * pageResult) {
        __weak typeof (self) weakSelf = self;
        weakSelf.currentPage = pageResult;
        [weakSelf.movies addObjectsFromArray:pageResult.movies];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
    
}

// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Swift Cell
    MovieSwiftCell* cell = (MovieSwiftCell*)[tableView dequeueReusableCellWithIdentifier:[MovieSwiftCell identifier] forIndexPath:indexPath];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    Movie* movie = [self.movies objectAtIndex:indexPath.row];
    [cell configureCellWithTitle:movie.title overview:movie.overView imageData:nil];
    
    return cell;
    
    /*
    // Objective C cell
    MovieCell* cell = (MovieCell*)[tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    if (cell == nil) {
        return [[UITableViewCell alloc] init];
    }
    
    // set information
    Movie* movie = [self.movies objectAtIndex:indexPath.row];
    [cell.titleLabel setText:movie.title];
    
    [[NetworkManager sharedInstance] getImageWithPath:movie.posterImage completion:^(UIImage * image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.posterView setImage:image];
        });
    }];
    
    return cell;
     */
}

// MARK: - UITableViewDataSourcePrefetching

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:(self.movies.count - 1) inSection:0];
    if ([indexPaths containsObject:lastIndexPath]) {
        [self fetchMovies];
    }
}

@end
