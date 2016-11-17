
#import "TvMovieFullController.h"


@interface TvMovieFullController ()
{
    TvMovieView *movieView;
    NSString *videoUrl;
    NSString *videoTitle;
    
    BOOL isFromOtherPlayer;
    
    CGRect orginFrame;
}

@end

@implementation TvMovieFullController

-(void)dealloc
{
    ReleaseClass;
    if (isFromOtherPlayer == NO) {
        [movieView destory];
    } else {
        [movieView setViewInterfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

-(instancetype)initWithUrl:(NSString *)url withTitle:(NSString *)title
{
    if (self = [super init]) {
        videoUrl = [[NSString alloc] initWithString:url];
        videoTitle = [[NSString alloc] initWithString:title];
        isFromOtherPlayer = NO;
    }
    return self;
}


-(instancetype)initWithMoviePlayer:(TvMovieView *)player
{
    if (self = [super init]) {
        videoUrl = @"";
        videoTitle = @"";
        movieView = player;
        isFromOtherPlayer = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *sBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    sBg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sBg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sBg];
    if (movieView == nil) {
        movieView = [[TvMovieView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/16*9)];
        [movieView playVideoWithRealUrl:videoUrl withTitle:videoTitle];
    }
    orginFrame = movieView.frame;
    [movieView setViewInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    movieView.tag = REMOVE_FOR_FULL_SCREEN;
    [self.view addSubview:movieView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (movieView.superview != self.view) {
        [self.view addSubview:movieView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    movieView.tag = 0;
    movieView.frame = orginFrame;
    [movieView removeFromSuperview];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return NO;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
