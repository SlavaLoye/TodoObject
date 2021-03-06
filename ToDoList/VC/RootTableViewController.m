//
//  RootTableViewController.m
//  ToDoList
//
//  Created by Вячеслав Лойе on 04/01/2019.
//  Copyright © 2019 Вячеслав Лойе. All rights reserved.
// 14 lesson https://www.youtube.com/watch?v=21pJcJ36rTU&index=14&list=PLmRNNqEA7JoMv0d1WGSb9Lz9hexlb092p

#import "RootTableViewController.h"

@interface RootTableViewController ()

@end

@implementation RootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.arrayEvents = [[NSMutableArray alloc]initWithArray:array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewWhenNewEvent) name:@"NewEvent" object:nil];
    //self.arrayEvents = [[NSMutableArray alloc] init];
   
    
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void) reloadTableViewWhenNewEvent {
    
    [self.arrayEvents removeAllObjects];
    NSArray *array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.arrayEvents = [[NSMutableArray alloc]initWithArray:array];
     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrayEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   
    UILocalNotification *notification = [self.arrayEvents objectAtIndex: indexPath.row];
    NSDictionary *dict = notification.userInfo;
    cell.textLabel.text = [dict objectForKey:@"eventInfo"];
    cell.detailTextLabel.text = [dict objectForKey:@"eventDate"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //мягкая анимация смягчает выделение 
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    UILocalNotification *notification = [self.arrayEvents objectAtIndex: indexPath.row];
    NSDictionary *dict = notification.userInfo;
    
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    
    // актуальное событие на момент запоминания
    viewController.eventInfo = [dict objectForKey: @"eventInfo"];
    viewController.eventDate = notification.fireDate;
    viewController.isDeteil = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UILocalNotification * notification = [self.arrayEvents objectAtIndex: indexPath.row];
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        
        [self.arrayEvents removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

@end


