//
//  AddWord.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 4/29/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "AddWord.h"
#import "MyPickerViewContrller.h"
#import "WordTypes.h"
#import "Words.h"
#import "WBEngine.h"
#import "WBRequest.h"
#import "WBConnection.h"
#import "RecordingViewController.h"
#import "JSON.h"
//#define radius 10

@implementation AddWord
@synthesize myTextFieldEng,myTextFieldRus,myPickerLabel;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                                  initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                                  target:self action:@selector(back)] autorelease];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                   target:self action:@selector(save)] autorelease];
        dataModel = [[AddWordModel alloc]init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    myWebView.layer.cornerRadius = 10;
}

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"] && !dataModel.currentWord) {
        [self showMyPickerView];
        return;
    }else if(!dataModel.wordType){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"]];
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            dataModel.wordType = [[types objectAtIndex:0] retain];
            myPickerLabel.text = dataModel.wordType.name;    
            [dataModel createWord];
            if (dataModel.currentWord) {
                [dataModel.currentWord setText:myTextFieldEng.text];
                [dataModel.currentWord setTranslate:myTextFieldRus.text];
                [dataModel.currentWord setType:dataModel.wordType];
                [dataModel.currentWord setTypeID:dataModel.wordType.typeID];
            }
        }else{
            [self showMyPickerView];
        }
    }else if(dataModel.currentWord && dataModel.wordType){
        editingWord = YES;
        myTextFieldEng.text = dataModel.currentWord.text;
        myTextFieldRus.text = dataModel.currentWord.translate;
        myPickerLabel.text = dataModel.wordType.name;
    }
}

- (void)setText:(NSString*)text{
    [dataModel createWord];
    myTextFieldEng.text = text;
    [dataModel.currentWord setText:text];
}

- (void)setTranslate:(NSString*)text{
    [dataModel createWord];
    myTextFieldRus.text = text;
    [dataModel.currentWord setTranslate:text];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMenu];
    [myTextFieldEng setFont:FONT_TEXT];
    [myTextFieldRus setFont:FONT_TEXT];
//   //[[NSNotificationCenter defaultCenter] 
//                                        addObserver:self 
//                                        selector:@selector(textFieldDidChange:)
//                                        name:UITextFieldTextDidChangeNotification  
//                                        object:myTextFieldEng];
    [myTextFieldEng addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [myTextFieldRus addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];;
//    [[NSNotificationCenter defaultCenter] 
//                                        addObserver:self 
//                                        selector:@selector(textFieldDidChange:)
//                                        name:UITextFieldTextDidChangeNotification  
//                                        object:myTextFieldRus];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputModeDidChange:)
                                                 name:@"UIKeyboardCurrentInputModeDidChangeNotification"
                                               object:nil];
    [self loadData];
    myTextFieldEng.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY];
    myTextFieldRus.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grnd.png"]];
    self.navigationItem.titleView = (UIView *)myToolbarView;
	[self setImageFlag];
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    id obj = [notification object];
    if ([obj respondsToSelector:@selector(inputModeLastUsedPreference)]) {
        id mode = [obj performSelector:@selector(inputModeLastUsedPreference)];
        NSLog(@"mode: %@", mode);
    }
}

- (void) closeAllKeyboard{
    [myTextFieldEng resignFirstResponder];
    [myTextFieldRus resignFirstResponder];
}

- (IBAction) recordPressed:(id)sender{
    //[sender setHidden:YES];
    [self closeAllKeyboard];
    if (recordView) {
        [recordView saveSound];
        [recordView release];
    }
    recordView = [[RecordingViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush; 
	myTransition.duration = 0.2;
    myTransition.subtype = kCATransitionFromRight;
    [recordView.view.layer addAnimation:myTransition forKey:@"RECORDANIMATION"];
    SoundType sounType;
    if (((UIButton *)sender).tag == 1) {
        if (!dataModel.currentWord.translate || [dataModel.currentWord.translate length] == 0) {
            [UIAlertView displayError:@"You must enter a word or choose a theme before recording."];
            return;
        }
        sounType = TRANSLATE;
        recordView.view.frame = CGRectMake(67, 88, 243, 40);
        myTextFieldRus.frame = CGRectMake(myTextFieldRus.frame.origin.x, myTextFieldRus.frame.origin.y , 48, myTextFieldRus.frame.size.height);
    }else{
        if (!dataModel.currentWord.text || [dataModel.currentWord.text length] == 0) {
            [UIAlertView displayError:@"You must enter a word before recording."];
            return;
        }
        sounType = TEXT;
        recordView.view.frame = CGRectMake(67, 48, 243, 40);
        myTextFieldEng.frame = CGRectMake(myTextFieldEng.frame.origin.x, myTextFieldEng.frame.origin.y , 48, myTextFieldEng.frame.size.height);
    }
    recordView.soundType = sounType;
    [recordView setWord:dataModel.currentWord withType:sounType];

    [self.view addSubview:recordView.view];
}

- (void) recordViewDidClose:(id)sender{
    if (((RecordingViewController *)sender).soundType == TRANSLATE) {
        myTextFieldRus.frame = CGRectMake(myTextFieldRus.frame.origin.x, myTextFieldRus.frame.origin.y , self.view.frame.size.width-22, myTextFieldRus.frame.size.height);
    }else{
        myTextFieldEng.frame = CGRectMake(myTextFieldEng.frame.origin.x, myTextFieldEng.frame.origin.y , self.view.frame.size.width-22, myTextFieldEng.frame.size.height);
    }
    
}

- (IBAction) showMyPickerView{
    if (myPicker) {
        [myPicker release];
    }
    myPicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	myPicker.delegate = self;
    [myPicker openViewWithAnimation:self.navigationController.view];
}

- (void) pickerDone:(WordTypes *)_wordType{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:_wordType.name] forKey:@"lastThemeInAddView"];
    dataModel.wordType = _wordType;
    [dataModel createWord];
    myPickerLabel.text = dataModel.wordType.name;
    if (dataModel.currentWord) {
        [dataModel.currentWord setType:dataModel.wordType];
        [dataModel.currentWord setTypeID:dataModel.wordType.typeID];
    }
    self.title = _wordType.name;
}

- (void) pickerWillCansel{
    if (!dataModel.currentWord) {
        [dataModel createWord];
    }
}

- (void) back{
	if (flgSave) {
        [self.navigationController popViewControllerAnimated:YES];
	}
	else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want save word?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
	}
}

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self save];
	}
	else if (buttonIndex == 0){
        if (!editingWord) {
            [dataModel.wordType removeWordsObject:dataModel.currentWord];
        }
        [self.navigationController popViewControllerAnimated:YES];
	}
	else if (buttonIndex == 0){
		return;
	}
}

- (IBAction) save
{
    [self closeAllKeyboard];
    [dataModel.currentWord setDescriptionStr:dataModel.wordType.name];
    [dataModel.currentWord setText:myTextFieldEng.text];
    [dataModel.currentWord setTranslate:myTextFieldRus.text];
    NSLog(@"%@",dataModel.currentWord);
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"Data is not saved."];
    }else{
       // [UIAlertView displayMessage:@"Data is saved."];
    }
	flgSave = YES;
    [self back];
}

- (void) setImageFlag{
    [self addRecButtonOnTextField:myTextFieldEng];
    [self addRecButtonOnTextField:myTextFieldRus];
    NSString *path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]];
	UIImageView *objImageRus = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageRus setFrame:CGRectMake(0.0, 0.0, 20, 18)];
	[myTextFieldEng setLeftView:objImageEng];
	[myTextFieldEng setLeftViewMode:UITextFieldViewModeAlways];
	[myTextFieldRus setLeftView:objImageRus];
	[myTextFieldRus setLeftViewMode:UITextFieldViewModeAlways];
    objImageEng.layer.cornerRadius = 10.0;
    objImageRus.layer.cornerRadius = 5.0;
	[objImageRus release];
	[objImageEng release];
} 

- (void)addRecButtonOnTextField:(UITextField*)textField{
    UIButton *recButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recButton addTarget:self 
               action:@selector(recordPressed:)
     forControlEvents:UIControlEventTouchDown];
    [recButton setImage:[UIImage imageNamed:@"Voice 24x24.png"] forState:UIControlStateNormal];
    recButton.frame = CGRectMake(0.0, 0.0, 24, 24);
    [recButton setTag:textField.tag];
	[textField setRightView:recButton];
	[textField setRightViewMode:UITextFieldViewModeAlways];
    if ([textField.text length]==0) {
        [recButton setEnabled:NO];
    }
}

- (void)setWord:(Words *)_word{
    [dataModel setWord:_word];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (IBAction) loadWebView
{
    if ([iTeachWordsAppDelegate isNetwork]) {
        [self closeAllKeyboard];
        [dataModel createUrls];
        [self loadTranslateTextFromServer];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:dataModel.urlShow]];
        myWebView.delegate = self;
        [myWebView loadRequest:requestObj];
    }
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
}


- (void) loadTranslateTextFromServer{
    if (!wbEngine) {
        wbEngine = [WBEngine new];
    }
    [dataModel createUrls];
    NSLog(@"%@",dataModel.url);
    WBRequest * request = [WBRequest getRequestWithURL:[dataModel.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] delegate:self];
    [wbEngine performRequest:request];
}

#pragma mark - WBConnection functions
- (void) connectionDidFinishLoading: (WBConnection*)connection {
	NSData *value = [connection data];
    NSString *response = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    NSDictionary *result = [[NSDictionary alloc] initWithDictionary:[response JSONValue]];
	if (result && ![[result objectForKey:@"responseData"] isEqual:[NSNull null]]) {        
        myTextFieldRus.text = [[result objectForKey:@"responseData"] objectForKey:@"translatedText"];
        [self textFieldDidEndEditing:myTextFieldRus];
	}else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"") 
                                                         message:@"Error connection" 
                                                        delegate:self 
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                                               otherButtonTitles: nil] autorelease];
        [alert show];
    }
    [result release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [response release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	if (textField == myTextFieldRus) {
		//[myTextFieldEng becomeFirstResponder];
	}
	else {
		[myTextFieldRus becomeFirstResponder];
	}
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    flgSave = NO;
}


- (void)textFieldDidChange:(UITextField*)textField {
    UIButton *recButton = ((UIButton*)textField.rightView);
    if ([textField.text length]==0) {
        [recButton setEnabled:NO];
    }else{
        [recButton setEnabled:YES];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = [NSString stringWithString:textField.text];
    [text removeSpaces];
    if ([text length] == 0) {
        return;
    }
    if (textField == myTextFieldEng) {
        [dataModel.currentWord setText:text];
    }else if (textField == myTextFieldRus) {
        [dataModel.currentWord setTranslate:text];
    }
}


- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"use as translate"
                                                       action:@selector(parceTranslateWord)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

- (void)parceTranslateWord{
    
    NSString *selectedText = [myWebView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    [myTextFieldRus setText:selectedText];
    [self textFieldDidChange:myTextFieldRus];
    NSLog(@"%@",selectedText);
}

- (void)dealloc {
    if (recordView) {
        [recordView release];
    }
    if (myPicker) {
        [myPicker release];
    }
    if (myWebView) {
        myWebView.delegate = nil;
        [myWebView release];
    }
    if (wbEngine) {
        [wbEngine release];
    }
    [dataModel release];
    [super dealloc];
}


@end
