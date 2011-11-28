//
//  DictionaryViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/2/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "DictionaryViewController.h"
#import "Words.h"
#import "AddWord.h"

@implementation DictionaryViewController
@synthesize searchedData,searchedText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchedData = [[NSMutableArray alloc]init];
        limit = 25;
        offset = 10;
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [searchedText release];
    [searchedData release];
    [super dealloc];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputModeDidChange:)
                                                 name:@"UIKeyboardCurrentInputModeDidChangeNotification"
                                               object:nil];
    cellStyle = UITableViewCellStyleSubtitle;
    [table setBackgroundColor:[UIColor whiteColor]];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"lastItem"];
    [super viewWillDisappear:animated];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadData { 
    if ([mySearchBar.text length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text BEGINSWITH[cd] %@", mySearchBar.text];
        [self loadDataWithPredicate:predicate];
        [table reloadData];
        return;
    }
    NSError *error;
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
    [request setFetchLimit:limit];  
    [request setFetchOffset:0];
    //[request setFetchBatchSize:10];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"text",@"translate", nil]];
    
	NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES 
                                                          selector:@selector(caseInsensitiveCompare:)];
    self.data = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:name, nil]];
    self.searchedData = [NSMutableArray arrayWithArray:self.data];
	[table reloadData];
}

-(void)loadDataWithPredicate:(NSPredicate *)predicate {
    NSString *key;
    NSString *nativeLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] lowercaseString];
    NSString *currentKeyboardLanguage = [self currentTextLanguage];
    NSString *textS = [NSString stringWithCString:[mySearchBar.text UTF8String] encoding:NSUTF8StringEncoding];
    if ([currentKeyboardLanguage isEqualToString:nativeLanguage]) {
        key = @"translate";
        predicate = [NSPredicate predicateWithFormat:@"translate BEGINSWITH[cd] %@", textS];
    }else{
        key = @"text";
        predicate = [NSPredicate predicateWithFormat:@"text BEGINSWITH[cd] %@", textS];
    }
    NSError *error;
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
//    [request setFetchLimit:limit];  
//    [request setFetchOffset:offset];
    //[request setFetchBatchSize:10];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"text",@"translate", nil]];
    [request setRelationshipKeyPathsForPrefetching:nil];
    [request setPredicate:predicate];
    
	NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:key ascending:YES 
                                                          selector:@selector(caseInsensitiveCompare:)];
    self.data = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:name, nil]];
    self.searchedData = [NSMutableArray arrayWithArray:self.data];
	[table reloadData];
}

- (NSString *)currentTextLanguage{
    NSArray *languageCode = [[[UITextInputMode currentInputMode] primaryLanguage] componentsSeparatedByString:@"-"];
    return [[languageCode objectAtIndex:0] lowercaseString];
}

- (bool)isNativeKeyboardLanguage{
    NSString *nativeLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] lowercaseString];
    NSString *currentKeyboardLanguage = [self currentTextLanguage];
    return ([currentKeyboardLanguage isEqualToString:nativeLanguage])?YES:NO;
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    id obj = [notification object];
    if ([obj respondsToSelector:@selector(inputModeLastUsedPreference)]) {
        id mode = [obj performSelector:@selector(inputModeLastUsedPreference)];
        NSLog(@"mode: %@", mode);
    }
}

- (void) loadLocalData{
    //searchedData = [NSMutableArray arrayWithArray:self.data];
    for (int i =0 ; i < [searchedData count]; i++) {
        Words *word = [searchedData objectAtIndex:i];
        NSString *wordText = ([self isNativeKeyboardLanguage])?word.translate:word.text;
        if (![wordText hasPrefix:mySearchBar.text]) {
            [searchedData removeObjectAtIndex:i];
            --i;
        }
    }
	[table reloadData];
}


#pragma mark search bar funktions
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([searchedData count] > limit) {
        return limit;
    }
    return [searchedData count];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    offset = 25; 
    limit = 25;
    searchBar.text = @"";
	[self loadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length]> 1) {
        offset = 5;
        limit = 5;
        if ([searchedText length] > [searchText length]) {
            self.searchedData = [NSMutableArray arrayWithArray:self.data];
        }
        [self loadLocalData];
        
    }else{
        [self loadData];
    }
    self.searchedText = mySearchBar.text;
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.row == limit-1) {
        return nil;
    }
    return nil;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < limit - 1) {
        return 44;
    }
    return 44;
}

#pragma mark - Table view delegate

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath*)indexPath {    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    NSArray *ar;
    [cell.textLabel setFont:FONT_TEXT];
    [cell.detailTextLabel setFont:FONT_TEXT];
    if ([mySearchBar.text length] > 0) {
        ar = self.searchedData;
    }else{
        ar = self.data;
    }
    if (indexPath.row < limit-1) {
        Words *word = [ar objectAtIndex:indexPath.row];
        cell.textLabel.text = ([self isNativeKeyboardLanguage])?word.translate:word.text;
        cell.detailTextLabel.text = ([self isNativeKeyboardLanguage])?word.text:word.translate;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"next %d words",offset];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < limit - 1) {
        AddWord *myAddWordView = [[AddWord alloc] initWithNibName:@"AddWord" bundle:nil];
        [myAddWordView setWord:[searchedData objectAtIndex:indexPath.row]];
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Menu" style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
        [[self navigationItem] setBackBarButtonItem: newBackButton];
        [self.navigationController pushViewController:myAddWordView animated:YES];
        [myAddWordView release]; 
        [newBackButton release];
    }else{
        limit += offset;
        if ([mySearchBar.text length] > 0) {
            [self loadDataWithPredicate:nil];
            return;
        }
        [self loadData];
    }
}


@end
