#import "HttpAccess.h"

#define URL_TEST @"http://yamato.main.jp/sample/test.txt"
#define BTN_READ 0

@implementation HttpAccess

- (UITextField*)makeTextField:(CGRect)rect text:(NSString*)text {
    UITextField* textField = [[[UITextField alloc] init] autorelease];
    [textField setText:text];
    [textField setFrame:rect];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [_textField setDelegate:self];
    return  textField;
}

- (UIButton*)makeButton:(CGRect)rect text:(NSString*)text tag:(int)tag {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:rect];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTag:tag];
    [button addTarget:self action:@selector(clickButton:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSString*)data2str:(NSData*)data {
    return [[[NSString alloc] initWithData:data
                                  encoding:NSUTF8StringEncoding] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _textField = [[self makeTextField:CGRectMake(0, 0, 300, 32)
                                 text:@""] retain];
    [self.view addSubview:_textField];
    
    UIButton* btnRead = [self makeButton:CGRectMake(0, 50, 90, 40)
                                    text:@"読込み" tag:BTN_READ];
    [self.view addSubview:btnRead];
    
    _indicator = [[UIActivityIndicatorView alloc] init];
    [_indicator setFrame:CGRectMake(140, 140, 40, 40)];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_indicator setHidesWhenStopped:YES];
    [self.view addSubview:_indicator];
}

- (void)dealloc {
    [_textField release];
    [_indicator release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField*)sender {
    [sender resignFirstResponder];
    return YES;
}

- (IBAction)clickButton:(UIButton*)sender {
    if (sender.tag==BTN_READ) {
        [_indicator startAnimating];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest* request = [NSURLRequest
                                     requestWithURL:[NSURL URLWithString:URL_TEST]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:30.0];
            NSError* error = nil;
            NSData* data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:nil error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error==nil) {
                    _textField.text = [self data2str:data];
                } else {
                    _textField.text = @"通信エラー";
                }
                [_indicator stopAnimating];
                
            });
        });
    }
}

@end




































