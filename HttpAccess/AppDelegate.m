#import "AppDelegate.h"
#import "HttpAccess.h"

@implementation AppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    UIViewController* viewCtl=[[[HttpAccess alloc] init] autorelease];
    _window.rootViewController=viewCtl;
    return YES;
}


- (void)dealloc
{
    [_window release];
    [super dealloc];
}



@end
