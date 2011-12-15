//
//  MyMenu.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/4/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import "MyMenu.h"
//#import "MyMenuCell.h"
//#import "TableWordController.h"
#import "TextViewController.h"
#import "LM15.h"
#import "LM7.h"
#import "AddWord.h"
#import "WorldTableToolsController.h"
#import "DictionaryViewController.h"
#import "MenuLessons.h"
#import "LanguagePickerController.h"
#import "SettingsViewController.h"
#import "InfoViewController.h"
#import "SpeachView.h"
#import "AddWordWebViewController.h"

@implementation MyMenu

@synthesize contentImageArray;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self ) {
        // Custom initialization
        [self.navigationItem setTitle:NSLocalizedString(@"Menu", @"")];
        data = [[NSArray alloc] initWithObjects:@"Word book",@"Lessons",@"Add new word",@"Text parser",@"Web",@"Dictionary",@"Settings", nil];
        contentImageArray = [[NSArray alloc] initWithObjects:@"folder_library",@"folder_private",@"Add new word",@"folder_documents-1", nil];
    }
    return self;
}

- (void)dealloc {
    [contentImageArray release];
    [super dealloc];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    for (int i=0;i<2;i++){
        int k=0;
        //ddddddddd
        //In new branch with error
    }
    
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    table.allowsSelectionDuringEditing = YES;
    [self addInfoButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

- (void)addInfoButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

- (void)showInfoView{
    InfoViewController *infoView = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
    [self.navigationController pushViewController:infoView animated:YES];
    [infoView release];
}

- (void)showLastItem{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastItem"]) {
        int lastItem = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastItem"];
        switch (lastItem) {
            case 0:
            case 1:
            case 4:
                [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastItem inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self tableView:table didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:lastItem inSection:0]];
                break;
            default:
                break;
        }
    }    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] || ![[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]){
        LanguagePickerController *languageView = [[LanguagePickerController alloc] initWithNibName:@"LanguagePickerController" bundle:nil];
        [self.navigationController pushViewController:languageView animated:YES];
        [languageView release];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [data count];
}

- (void) configureCell:(UITableViewCell *)theCell forRowAtIndexPath:(NSIndexPath *)indexPath{
    theCell.selectionStyle = UITableViewCellSelectionStyleGray;
    theCell.textLabel.text = [data objectAtIndex:indexPath.row];
   // [theCell.imageView setImage:[UIImage imageNamed:[contentImageArray objectAtIndex:indexPath.row]]];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"lastItem"];
    switch (indexPath.row) {
        case 0:{
            WorldTableToolsController *myTableView = [[WorldTableToolsController alloc] initWithNibName:@"WorldTableViewController" bundle:nil];
            [self.navigationController pushViewController:myTableView animated:YES];
            [myTableView release];          
        }
            break;
        case 1:{
            MenuLessons *lessonMenu = [[MenuLessons alloc] initWithNibName:@"MenuLessons" bundle:nil];
            [self.navigationController pushViewController:lessonMenu animated:YES];


            
//            LM7 *lessonMaker = [[LM7 alloc] initWithNibName:@"LM7" bundle:nil];
//            [self.navigationController pushViewController:lessonMaker animated:YES];
//            lessonMaker.textContent = @"Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user. Quits the application and it begins the transition to the background state.";
//            [lessonMaker release];

        }
            break;
        case 2:{
            AddWord *myAddWordView = [[AddWord alloc] initWithNibName:@"AddWord" bundle:nil];
            
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Menu" style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
            [[self navigationItem] setBackBarButtonItem: newBackButton];
            [self.navigationController pushViewController:myAddWordView animated:YES];
            [myAddWordView release]; 
            [newBackButton release];
        }
            break;           
        case 3:{
            TextViewController *myTextView = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
            [self.navigationController pushViewController:myTextView animated:YES];
            [myTextView release]; 
        }
            break;          
        case 4:{
            [self showWebView]; 
        }
            break;         
        case 5:{
            DictionaryViewController *dictionaryView = [[DictionaryViewController alloc] initWithNibName:@"DictionaryViewController" bundle:nil];
            [self.navigationController pushViewController:dictionaryView animated:YES];
            [dictionaryView release]; 
        }
            break;       
        case 6:{
//            LanguagePickerController *languageView = [[LanguagePickerController alloc] initWithNibName:@"LanguagePickerController" bundle:nil];
//            [self.navigationController pushViewController:languageView animated:YES];
//            [languageView release];          
            
            SettingsViewController *languageView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
            [self.navigationController pushViewController:languageView animated:YES];
            [languageView release];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showWebView {
    AddWordWebViewController *webViewController = [[AddWordWebViewController alloc] initWithFrame:self.view.frame];
    NSString *url = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastUrl"];
    if(!url){
        url = @"http://www.google.ru";
    }
    webViewController.url = url;
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}

@end

