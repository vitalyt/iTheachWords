//
//  TestGameController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/9/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExersiceBasicClass.h"

@interface TestGameController : ExersiceBasicClass {
	Words		*word;
	int         index;
}

- (void)		createWord;
- (NSString *)	QQQ:(NSString *) _word charIn:(const char)ch;
- (void)		setText:(NSString *)str;
- (void)		capitalizeText: (NSNotification*)notification;
- (void)		onHideKeyboard:(id)notification;

@end
