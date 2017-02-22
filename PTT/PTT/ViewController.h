//
//  ViewController.h
//  PTT
//
//  Created by willard on 2017/2/21.
//  Copyright © 2017年 willard. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP

@interface ViewController : UIViewController <GCDAsyncSocketDelegate>


@end

