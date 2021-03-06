//
//  LoginViewController.m
//  BeautifulDaRen
//
//  Created by gang liu on 4/25/12.
//  Copyright (c) 2012 myriad. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountInfoInputCell.h"
#import "RegisterViewController.h"
#import "ButtonViewCell.h"
#import "SinaSDKManager.h"
#import "QZoneSDKManager.h"
#import "FindPasswordViewController.h"

#import "ViewHelper.h"

@interface LoginViewController()

@property (retain, nonatomic) IBOutlet UITableView * tableView;
@property (retain, nonatomic) IBOutlet UIButton * loginWithQQButton;
@property (retain, nonatomic) IBOutlet UIButton * loginWithSinaWeiboButton;

- (IBAction)loginButtonSelected:(id)sender;

@end

@implementation LoginViewController
@synthesize tableView = _tableView;
@synthesize loginWithQQButton =_loginWithQQButton;
@synthesize loginWithSinaWeiboButton = _loginWithSinaWeiboButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"login", @"login")];
        [self.navigationItem setLeftBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onBackButtonClicked) title:NSLocalizedString(@"go_back", @"go_back")]];
        [self.navigationItem setRightBarButtonItem:[ViewHelper getBarItemOfTarget:self action:@selector(onFindPasswordButtonClicked) title:NSLocalizedString(@"find_password", @"find_password")]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)onSinaLoginButtonPressed:(id)sender
{
    [[SinaSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"Sina SDK login done, status:%d", status);
    }];
}

-(IBAction)onTencentLoginButtonPressed:(id)sender
{
    [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
        NSLog(@"QZone SDK login done, status:%d", status);
    }];
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onFindPasswordButtonClicked
{
    FindPasswordViewController * findPasswordViewController = [[[FindPasswordViewController alloc] initWithNibName:@"FindPasswordViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:findPasswordViewController animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    switch (section) {
        case 0:
        {
            number = 2;
            break;
        }   
        case 1:
        case 2:
        case 3:
        {
            number = 1;
            break;
        }
    }
    return number;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * account_input_identifier = @"AccountInfoInputCell";
    static NSString * button_view_identifier = @"ButtonViewCell";
    UITableViewCell * cell = nil;
    NSInteger section = [indexPath section];
    if(section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:account_input_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:account_input_identifier owner:self options:nil] objectAtIndex:0];
        }
        switch ([indexPath row])
        {
            case 0:
            {
                // "user name"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"user_name", @"user name");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
            case 1:
            {
                // "password"
                ((AccountInfoInputCell*)cell).inputLabel.text = NSLocalizedString(@"password", @"password");
                ((AccountInfoInputCell*)cell).inputTextField.delegate = self;
                break;
            }
        }
    }
    else if(section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:4];
        }
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"buttonBackGround"];
        ((ButtonViewCell*)cell).leftLabel.text = NSLocalizedString(@"enter", @"enter");
        
        cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    else if (section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:button_view_identifier];
        if(!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:button_view_identifier owner:self options:nil] objectAtIndex:1];
        }
        ((ButtonViewCell*)cell).buttonText.text = NSLocalizedString(@"not_user_to_register", @"You are not user, please register");
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"next_flag"]; 
    }
    else if (section == 3)
    {
        cell = [ViewHelper getLoginWithExtenalViewCellInTableView:tableView cellForRowAtIndexPath:indexPath];
        _loginWithSinaWeiboButton = ((ButtonViewCell*)cell).leftButton;
        ((ButtonViewCell*)cell).buttonLeftIcon.image = [UIImage imageNamed:@"sina_weibo_icon"];
        _loginWithQQButton = ((ButtonViewCell*)cell).rightButton;
        ((ButtonViewCell*)cell).buttonRightIcon.image = [UIImage imageNamed:@"qq_icon"];
        ((ButtonViewCell*)cell).delegate = self;
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 2)
    {
        RegisterViewController * registerController = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil] autorelease];
        [self.navigationController pushViewController:registerController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 3;
    if(section == 3 || section == 0)
    {
        height = 20;
    }
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = nil;
    if(section == 3)
    {
        view = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewHeaderView" owner:self options:nil] objectAtIndex:0];
        UILabel * label = (UILabel*)[view viewWithTag:1];
        label.text = NSLocalizedString(@"login_with_cooperation", @"login_with_cooperation");
    }
    else
    {
        view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 3;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}


#pragma mark LoginViewController
- (IBAction)loginButtonSelected:(id)sender
{
    NSLog(@"TODO loginButtonSelected IN LoginViewController.m");
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark ButtonPressDelegate
- (void)didButtonPressed:(UIButton *)button inView:(UIView *)view
{
    if(button ==  self.loginWithSinaWeiboButton)
    {
        NSLog(@"loginWithSinaWeiboButton");
    }
    else if(button == self.loginWithQQButton)
    {
        [[QZoneSDKManager sharedManager] loginWithDoneCallback:^(LOGIN_STATUS status) {
            NSLog(@"QZone login done, status:%d", status);
        }];
    }
}

@end
