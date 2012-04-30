//
//  WeiboDetailViewController.h
//  BeautifulDaRen
//
//  Created by jerry.li on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInforCellViewController.h"

@interface WeiboDetailViewController : UIViewController

@property (nonatomic, retain) UserInforCellViewController * userInforCellView;
@property (nonatomic, retain) IBOutlet UIScrollView * detailScrollView;
@property (nonatomic, retain) NSString * userId;

@property (nonatomic, retain) IBOutlet UILabel  * contentLabel;

@property (nonatomic, retain) IBOutlet UIButton * forwardButton;
@property (nonatomic, retain) IBOutlet UIButton * commentButton;
@property (nonatomic, retain) IBOutlet UIButton * favourateButton;

@end
