//
//  TestOneOfSix.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/2/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import "TestOneOfSix.h"
#import "StatisticViewController.h"
#import "DetailStatisticModel.h"
//#import "MultiPlayer.h"

#define COUNT = 6;
#define WORD(array,index) ((Words *)[array objectAtIndex:index])

@implementation TestOneOfSix

@synthesize contentArray,table;

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        contentArray = [[NSMutableArray alloc] init];
        statisticView = [[StatisticViewController alloc] initWithNibName:@"StatisticViewController" bundle:nil];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                   initWithTitle:@"?" style:UIBarButtonItemStyleBordered target:self action:@selector(help)] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.titleView = statisticView.view;
    if([self.data count]>0){
        [self createWord];
    }
}

- (void) createWord{
    flgChange = NO;
    if([self randomFrom:0 to:2]>0){
        flgChange = YES;
    }
    int _count = 6;
    if ([self.data count]<6) {
		_count = [self.data count]-1;
	}
    if (contentArray) {
        
        [contentArray release];
    }
    contentArray = [(NSMutableArray *) [self mixingArray:self.data count:_count] retain] ;
    [self.table reloadData];
}

-(int) randomFrom:(int)from to:(int)to{
	srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));
    int randomValue = 0;
    if ((to - from) != 0) {
        randomValue = from+ (random() % (to - from));
    }
	return randomValue;
}

- (NSMutableArray *) mixingArray:(NSArray *)_array count:(int)_count{
    //[_array autorelease];
    if([_array count]<_count){
        return (NSMutableArray *)_array;
    }
    NSMutableArray *oldArray = [[NSMutableArray alloc] initWithArray:_array];
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    NSArray *statistic = [self getStatisticIndexesArrayWithWords:oldArray];
    //set major word
    int randomIndexMajor = [self randomFrom:0 to:[statistic count]];
    int index = [[statistic objectAtIndex:randomIndexMajor] intValue];
    [newArray addObject:[_array objectAtIndex:index]];
    //
    
    BOOL flgExistMajor = NO;
	int count = _count;
    int i=0; 
	while (i < count) {
		int randomIndex = [self randomFrom:0 to:[oldArray count]];
		[newArray addObject:[oldArray objectAtIndex:randomIndex]];
		[oldArray removeObjectAtIndex:randomIndex];
        if([[newArray lastObject] isEqual:[_array objectAtIndex:index]]){
            flgExistMajor = YES;
        }
        i++;
	}
    //and translate
    if(!flgExistMajor){
        int randomIndex = [self randomFrom:1 to:[newArray count]];
        [newArray replaceObjectAtIndex:randomIndex withObject:[_array objectAtIndex:index]];
    }
	[oldArray release];
	return [newArray autorelease];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([self.data count] <= 0){
        return 0;
    }
    if(section == 0){
        return 1;
    }
	if ([self.data count]<6) {
		return [self.data count]-1;
	}
    return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.numberOfLines = 2;
    [cell.textLabel setFont:FONT_TEXT];
    if(indexPath.section == 0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(flgChange){
            cell.textLabel.text = WORD(contentArray,0).text;
        }else{
            cell.textLabel.text = WORD(contentArray,0).translate;
        }
		cell.textLabel.textAlignment =  UITextAlignmentCenter;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if(!flgChange){
            cell.textLabel.text = WORD(contentArray,indexPath.row+1).text;
        }else{
            cell.textLabel.text = WORD(contentArray,indexPath.row+1).translate;
        }
    }    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
	if([WORD(contentArray,indexPath.row+1) isEqual:WORD(contentArray,0)]){
        [self checkingWord:WORD(contentArray,0) success:YES];
        statisticView.right++;
        [self playSoundWithIndex:0];
        [self showTestMessageResultat:YES];
        [self performSelector:@selector(createWord) withObject:nil afterDelay:1.5f];
    }else{
        [self checkingWord:WORD(contentArray,0) success:NO];
        [self showTestMessageResultat:NO];
    }        
    statisticView.index++; 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) playSoundWithIndex:(int)index{
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    NSArray *sounds = [[NSArray alloc] initWithObjects:WORD(contentArray,index), nil];
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"MultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:sounds];
    [sounds release];
}

- (IBAction) help{
    for (int i=1;i<[contentArray count];i++){
        if([WORD(contentArray,i) isEqual:WORD(contentArray,0)]){
            
            [table selectRowAtIndexPath:[NSIndexPath indexPathForRow:i-1 inSection:1] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self checkingWord:WORD(contentArray,0) success:YES];
            [self playSoundWithIndex:0];
            [self performSelector:@selector(createWord) withObject:nil afterDelay:1.5f];
        }
    }
    statisticView.index++;
}

- (void)createBunnerView{
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    float offset = self.view.frame.size.height + adView.frame.size.height;
    adView.frame = CGRectMake(0, offset, adView.frame.size.width, adView.frame.size.height);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self.view addSubview:adView];
    [self.view bringSubviewToFront:adView];
    adView.delegate=self;
    self.bannerIsVisible=NO;
}

#pragma mark ADBannerView

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        float offset = self.view.frame.size.height - adView.frame.size.height;
        [table setFrame:CGRectMake(0, 0, table.frame.size.width, table.frame.size.height-banner.frame.size.height)];
        banner.frame = CGRectMake(0, offset, banner.frame.size.width, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        [table setFrame:CGRectMake(0, 0, table.frame.size.width, table.frame.size.height+banner.frame.size.height)];
        float offset = self.view.frame.size.height + adView.frame.size.height;
        banner.frame = CGRectMake(0, offset, banner.frame.size.width, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    if (contentArray) {
        [contentArray release];
    }
    [super dealloc];
}


@end

