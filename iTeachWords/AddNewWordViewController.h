//
//  AddNewWordViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/5/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "RecordingViewProtocol.h"
#import "AddWordModel.h"

@class MyPickerViewContrller,MyUIViewClass,RecordingViewController,AddWordModel,WBEngine;

@interface AddNewWordViewController : UIViewController <UITextFieldDelegate, RecordingViewProtocol, UIActionSheetDelegate>{
	IBOutlet UIPickerView	*myPickerView;
    IBOutlet UITextField    *textFld;
    IBOutlet UITextField    *translateFid;
    IBOutlet UILabel *themeLbl;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *themeButton;
    IBOutlet MyUIViewClass  *myToolbarView;
	MyPickerViewContrller	*myPicker;
    IBOutlet UIButton       *recordButtonView;
    RecordingViewController *recordView;
    
    id                      delegate;
    
    AddWordModel            *dataModel;
    bool                    flgSave;
    bool                    editingWord;
}

@property (nonatomic) bool flgSave,editingWord;
@property (nonatomic, retain)  AddWordModel            *dataModel;
@property (nonatomic, assign)  id            delegate;

- (void)inputModeDidChange:(NSNotification*)notificationl;
- (void)     loadData;
- (IBAction) showMyPickerView;

- (IBAction) save;
- (IBAction) recordPressed:(id)sender;

- (void)	 setImageFlag;
- (void)     closeAllKeyboard;

- (void)setWord:(Words *)_word;
- (void)setText:(NSString*)text;
- (void)setTranslate:(NSString*)text;
- (void)addRecButtonOnTextField:(UITextField*)textField;
- (void)createMenu;
- (void)textFieldDidChange:(UITextField*)textField;
- (void)setThemeName;
- (void)removeChanges;

@end
