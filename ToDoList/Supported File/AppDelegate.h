//
//  AppDelegate.h
//  ToDoList
//
//  Created by Вячеслав Лойе on 04/01/2019.
//  Copyright © 2019 Вячеслав Лойе. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

