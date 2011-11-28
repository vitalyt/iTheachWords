    //
//  ToolsViewController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/20/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "ToolsViewController.h"
#import "RecordingViewController.h"
#import "TestsViewController.h"
#import "EditingView.h"
#import "ManagerViewController.h"
#import "WorldTableViewController.h"

@implementation ToolsViewController

@synthesize delegate,visible,mySlider,isShowingView;

- (IBAction) clickManaging:(id)sender{
    managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    managerView.toolsViewDelegate = self;
    managerView.managerViewDelegate = self.delegate;
    [self toolbarAddSubView:managerView.view after:sender];
    managerView.segmentControll.selectedSegmentIndex = ((WorldTableViewController*)delegate).showingType;
}

- (IBAction) clickEdit:(id)sender{
	if ([self.delegate respondsToSelector:@selector(clickEdit)]) {
		[self.delegate clickEdit];
	}
    editingView = [[EditingView alloc] initWithNibName:@"EditingView" bundle:nil];
    editingView.toolsViewDelegate = self;
    editingView.editingViewDelegate = self.delegate;
    [self toolbarAddSubView:editingView.view after:sender];
}

- (IBAction) showPlayerView{
	if ([(id)self.delegate respondsToSelector:@selector(showPlayerView)]) {
		[(id)self.delegate showPlayerView];
		self.visible = NO;
		//[self.view removeFromSuperview];
		return;
	}
}

- (IBAction) showThemesView{
	if ([(id)self.delegate respondsToSelector:@selector(showThemesView)]) {
		[(id)self.delegate showThemesView];
		return;
	}
}

- (IBAction) changeSlider:(id)sender{
	if ([(id)self.delegate respondsToSelector:@selector(changeSlider:)]) {
		[(id)self.delegate changeSlider:sender];
		return;
	}
}

- (IBAction) showRecordingView:(id)sender{
    // ((UIBarButtonItem *)sender).customView.hidden = YES;
	if ([(id)self.delegate respondsToSelector:@selector(showRecordingView)]) {
        [(id)self.delegate showRecordingView];
        //[self showToolsView:nil];
        return;
     }
    recordingView = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
    recordingView.toolsViewDelegate = self;
    [self toolbarAddSubView:recordingView.view after:sender];
}

- (void) optionsSubViewDidClose:(id)sender{
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
}

- (void) editingSubViewDidClose:(id)sender{
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
    if ([(id)self.delegate respondsToSelector:@selector(clickEdit)]) {
        [(id)self.delegate clickEdit];
    }
   // [((TableWordController *)self.delegate) clickEdit];
}

- (void) managerSubViewDidClose:(id)sender{
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
}

- (IBAction) showTestsView:(id)sender{
    // ((UIBarButtonItem *)sender).customView.hidden = YES;
	if ([(id)self.delegate respondsToSelector:@selector(showTestsView)]) {
        [(id)self.delegate showTestsView];
        
        return;
    }
    testsView = [[TestsViewController alloc] initWithNibName:@"TestsViewController" bundle:nil];
    testsView.toolsViewDelegate = self;
    testsView.testsViewDelegate = self.delegate;
    [self toolbarAddSubView:testsView.view after:sender];
}

- (IBAction) showToolsView:(id)sender{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush;  
    if(self.view.frame.origin.x < -10.0){
        isShowingView = YES;
        myTransition.subtype = kCATransitionFromLeft;
        [self.view.layer addAnimation:myTransition forKey:nil];
        [self.view setFrame:CGRectMake(-10.0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        isShowingView = NO;
        myTransition.subtype = kCATransitionFromRight;
        [self.view.layer addAnimation:myTransition forKey:nil];
        [self.view setFrame:CGRectMake(-328.0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void) removeOptionWithIndex:(int)index{
    ((UIBarButtonItem*) [[toolbar items] objectAtIndex:index]).enabled = NO;
}

/*
- (void) createAllButtons{
    float indentX = 10.0;
    float indentY = (self.view.frame.size.height - 40.0)/2.0 ;
    int count = 10;
    float width = 0.0;
    for (int i=0; i<count; i++) {
        width += indentX;
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width, indentY, 50.0, 40.0)];
        // [button addTarget:selfaction:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
        //[button setTitle:@"player" forState:UIControlStateNormal];
        [scrollView addSubview:button];
        NSString *imageName;
        if(((int)i%2) == 0){
            imageName = @"play.png";
        } 
        else {
            imageName = @"refresh.png";
        }
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        width += button.frame.size.width;
        [button release];
		
	}
	scrollView.contentSize	= CGSizeMake(width, scrollView.frame.size.height);
}
*/
- (void) openViewWithAnimation:(UIView *) superView{
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush; 
	myTransition.subtype = kCATransitionFromLeft;
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, superView.frame.size.height - self.view.frame.size.height+3, self.view.frame.size.width, self.view.frame.size.height)]; 
	[self.view.layer addAnimation:myTransition forKey:nil]; 
	[superView addSubview:self.view];
    isShowingView = YES;
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void) closeView{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush; 
	myTransition.subtype = kCATransitionFromRight;
    
	[self.view.layer addAnimation:myTransition forKey:nil];
	[self.view removeFromSuperview];
    isShowingView = NO;
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void) toolbarAddSubView:(UIView *)_subView after:(id)sender{
    NSMutableArray *items = [[toolbar items] mutableCopy];
    UIBarButtonItem *recordingButton = [[UIBarButtonItem alloc] initWithCustomView:_subView];
    int index = [items indexOfObject:sender]+1;
    [recordingButton setTag:index];
    [_subView setTag:index];
    [items insertObject:recordingButton atIndex:[items indexOfObject:sender]+1];
    [recordingButton release];
    ((UIBarButtonItem *)sender).enabled = NO;
    [toolbar setItems:nil];
    [toolbar setFrame:CGRectMake(0.0, 0.0, 
                                 toolbar.frame.size.width + _subView.frame.size.width, 
                                 toolbar.frame.size.height)];    
    scrollView.contentSize	= CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
    [toolbar setItems:items animated:YES];
    float offset = _subView.frame.origin.x+_subView.frame.size.width - scrollView.contentOffset.x - 320.0;
    if (offset > 0.0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + (_subView.frame.origin.x+_subView.frame.size.width - scrollView.contentOffset.x - 320.0)  , 0.0);
    }
    [items release];
}

- (void) toolbarRemoveSubView:(UIView *)_subView{
    NSMutableArray *items = [[toolbar items] mutableCopy];
    
    for(int i=0;i<[items count]-1;i++){
        if((((UIBarButtonItem *)[items objectAtIndex:i]).enabled == NO) 
           && (((UIBarButtonItem *)[items objectAtIndex:i+1]).tag == _subView.tag)){
            ((UIBarButtonItem *)[items objectAtIndex:i]).enabled = YES;
            [items removeObjectAtIndex:i+1];
            [toolbar setItems:nil];
            [toolbar setFrame:CGRectMake(0.0, 0.0, 
                                         toolbar.frame.size.width - _subView.frame.size.width, 
                                         toolbar.frame.size.height)];    
            scrollView.contentSize	= CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
            //scrollView.contentOffset = CGPointMake(0.0, 0.0);
            
            break;
        }
    }
    [toolbar setItems:items animated:YES];
    [items release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize	= CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
   // [self createAllButtons];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) clickStatistic{
    
}

- (void)dealloc {
    if(recordingView != nil){
        [recordingView release];
    }
    if(testsView != nil){
        [testsView release];
    }
    [mySlider release];
    [super dealloc];
}


@end
