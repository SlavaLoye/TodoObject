//
//  RootTableViewController.h
//  ToDoList
//
//  Created by Вячеслав Лойе on 04/01/2019.
//  Copyright © 2019 Вячеслав Лойе. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RootTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *arrayEvents;

@end

NS_ASSUME_NONNULL_END
