//
//  ToolsViewController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/20/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolsViewProtocol.h"
#import "QuartzCore/QuartzCore.h"
#import "RecordingViewProtocol.h"
#import "TestsViewProtocol.h"

@class  RecordingViewController,
        TestsViewController,
        EditingView,
        ManagerViewController;
@interface ToolsViewController : UIViewController <RecordingViewProtocol,TestsViewProtocol,ToolsViewProtocol> {
	id	<ToolsViewProtocol> delegate;
	IBOutlet UISlider       *mySlider;
    IBOutlet UIScrollView   *scrollView;
    IBOutlet UIToolbar      *toolbar; 
	BOOL                    visible;
    IBOutlet UIBarButtonItem *testItemsButton;
    RecordingViewController  *recordingView;
    TestsViewController      *testsView;
    EditingView              *editingView;
    ManagerViewController    *managerView;
    bool                    isShowingView;
}

@property (nonatomic,retain) id  delegate;
@property (nonatomic) bool  isShowingView;
@property (nonatomic,retain) IBOutlet UISlider *mySlider;
@property (nonatomic) BOOL visible;

- (IBAction) clickManaging:(id)sender;
- (IBAction) clickEdit:(id)sender;
- (IBAction) showPlayerView;
- (IBAction) showToolsView:(id)sender;
- (IBAction) showRecordingView:(id)sender;

- (void) toolbarAddSubView:(UIView *)_subView after:(id)sender;
- (void) toolbarRemoveSubView:(UIView *)_subView;

- (void)     openViewWithAnimation:(UIView *) superView;
- (void)     closeView;
- (void)    removeOptionWithIndex:(int)index;

@end
