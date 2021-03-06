//
//  MyShowViewController.m
//  BeautifulDaRen
//
//  Created by jerry.li on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyShowViewController.h"
#import "ViewConstants.h"
#import "PhotoConfirmViewController.h"

@interface MyShowViewController ()
@property (nonatomic, assign) UIImagePickerControllerSourceType currentType;
@property (nonatomic, assign) BOOL shouldShowSelf;
@end

@implementation MyShowViewController

@synthesize takePhotoViewController = _takePhotoViewController;
@synthesize selectPhotoViewController = _selectPhotoViewController;
@synthesize currentType = _currentType;
@synthesize shouldShowSelf = _shouldShowSelf;

- (void)dealloc
{
    [self.takePhotoViewController release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.takePhotoViewController =
        [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        self.currentType = UIImagePickerControllerSourceTypeCamera;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.takePhotoViewController =
    [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [self.takePhotoViewController setDelegate:self];
    self.currentType = UIImagePickerControllerSourceTypeCamera;
    self.shouldShowSelf = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([UIImagePickerController isSourceTypeAvailable:self.currentType] && self.shouldShowSelf)
    {
        if (self.currentType == UIImagePickerControllerSourceTypeCamera) {
            [self.takePhotoViewController setupImagePicker:self.currentType];
            [self presentModalViewController:self.takePhotoViewController.imagePickerController animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.takePhotoViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TakePhotoControllerDelegate

- (void)didTakePicture:(UIImage *)picture
{
    self.shouldShowSelf = NO;
    PhotoConfirmViewController *photoConfirmViewControlller = 
    [[[PhotoConfirmViewController alloc] initWithNibName:@"PhotoConfirmViewController" bundle:nil] autorelease];
    //    photoConfirmViewControlller.delegate = self;
    [photoConfirmViewControlller.photoImageView setImage:[UIImage imageNamed:@"toolbar_button"]];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController: photoConfirmViewControlller];
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self.navigationController presentModalViewController:navController animated:YES];
        [navController release];
    }];
}

- (void)didFinishWithCamera
{
    [self.tabBarController setSelectedIndex:0];
    [self dismissModalViewControllerAnimated:YES];
    self.currentType = UIImagePickerControllerSourceTypeCamera;
}

- (void)didChangeToGalleryMode
{
    self.currentType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.shouldShowSelf = NO;
    
    if (_selectPhotoViewController == nil) {
        self.selectPhotoViewController =
        [[[TakePhotoViewController alloc] initWithNibName:nil bundle:nil] autorelease];
        
        [self.selectPhotoViewController setDelegate:self];
    }
    [self dismissViewControllerAnimated:NO completion:^{
        [self.selectPhotoViewController setupImagePicker:self.currentType];
        [self.parentViewController presentModalViewController:self.selectPhotoViewController.imagePickerController animated:YES];
    }];
}
@end
