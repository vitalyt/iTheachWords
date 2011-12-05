//
//  AddWord.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 4/29/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class MyUIViewClass,AddNewWordViewController;

@interface AddWord : UIViewController <UIWebViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>{
	IBOutlet UINavigationBar *myNavigationBar;
	IBOutlet UIWebView		*myWebView;
    IBOutlet MyUIViewClass  *myToolbarView;
    IBOutlet UIView         *loadWebButtonView;
    
    AddNewWordViewController    *wordsView;
}

@property (nonatomic, assign) IBOutlet UILabel *myPickerLabel;
@property (nonatomic, retain) IBOutlet UITextField *myTextFieldEng,*myTextFieldRus;

- (void)     back;
- (IBAction) loadWebView;
- (void)setThemeName;
- (IBAction) showMyPickerView;
- (void)save;
- (void)showWebLoadingView;
- (void)setText:(NSString*)text;
- (void)setTranslate:(NSString*)text;
@end
