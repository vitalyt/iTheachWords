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
#import "RecordingViewProtocol.h"
#import "AddWordModel.h"

@class MyPickerViewContrller,MyUIViewClass,RecordingViewController,AddWordModel,WBEngine;

@interface AddWord : UIViewController <UIWebViewDelegate, UITextFieldDelegate, RecordingViewProtocol, UIActionSheetDelegate>{
	IBOutlet UINavigationBar *myNavigationBar;
	IBOutlet UIWebView		*myWebView;
	IBOutlet UIPickerView	*myPickerView;
	IBOutlet UILabel		*myPickerLabel;
	IBOutlet UITextField	*myTextFieldEng,*myTextFieldRus;
    IBOutlet MyUIViewClass  *myToolbarView;
    IBOutlet UIButton       *recordButtonView;
    IBOutlet UIView         *loadWebButtonView;
	MyPickerViewContrller	*myPicker;
    RecordingViewController *recordView;
    
    AddWordModel            *dataModel;
    bool                    flgSave;
    bool                    editingWord;
    
    WBEngine                *wbEngine;
}

@property (nonatomic, assign) IBOutlet UILabel *myPickerLabel;
@property (nonatomic, retain) IBOutlet UITextField *myTextFieldEng,*myTextFieldRus;


- (void)inputModeDidChange:(NSNotification*)notificationl;
- (void)     loadData;
- (IBAction) showMyPickerView;
- (void)     back;

- (IBAction) save;
- (IBAction) recordPressed:(id)sender;
- (IBAction) loadWebView;

- (void)	 setImageFlag;
- (void)     closeAllKeyboard;
- (void) loadTranslateTextFromServer;

- (void)setWord:(Words *)_word;
- (void)setText:(NSString*)text;
- (void)setTranslate:(NSString*)text;
- (void)addRecButtonOnTextField:(UITextField*)textField;
- (void)createMenu;
- (void)textFieldDidChange:(UITextField*)textField;
- (void)setThemeName;

@end
