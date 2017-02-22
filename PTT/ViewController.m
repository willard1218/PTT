//
//  ViewController.m
//  PTT
//
//  Created by willard on 2017/2/21.
//  Copyright © 2017年 willard. All rights reserved.
//

#import "ViewController.h"
@interface ViewController () {
    GCDAsyncSocket *socket;
    NSStringEncoding big5 ;
    NSString *account;
    NSString *password;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    big5 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5_HKSCS_1999);
    
    account = @"";
    password = @"";
    [socket connectToHost:@"ptt.cc" onPort:23 error:nil];
    [self pttCommand:account];
}

-(void)pttCommand:(NSString *)command {
    
    
  
    command = [command stringByAppendingString:@"\r\n"];
    NSData *commandData = [command dataUsingEncoding:big5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [socket writeData:commandData withTimeout:-1.0 tag:0];
        [socket readDataWithTimeout:-1.0 tag:0];
    });
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"connect");
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [sock readDataWithTimeout:-1 tag:0];
    NSString *respone = [[NSString alloc] initWithData:data encoding:big5];
    if ([respone rangeOfString:@"請輸入您的密碼"].location != NSNotFound) {
        [self pttCommand:password];
    }
    else if ([respone rangeOfString:@"您想刪除其他重複登入的連線嗎"].location != NSNotFound) {
        [self pttCommand:@"n"];
    }
    else if ([respone rangeOfString:@"請按任意鍵繼續"].location != NSNotFound) {
        [self pttCommand:@""];
        [self pttCommand:@"u"];
        [self pttCommand:@"i"];
    }
    else if ([respone rangeOfString:@"您要刪除以上錯誤嘗試的記錄嗎"].location != NSNotFound) {
        [self pttCommand:@"y"];
    }
    else if ([respone rangeOfString:@"代號暱稱"].location != NSNotFound) {
        
    }
    NSLog(respone);
    NSLog(@"\n\n\n");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
