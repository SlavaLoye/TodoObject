//
//  ViewController.m
//  ToDoList
//
//  Created by Вячеслав Лойе on 04/01/2019.
//  Copyright © 2019 Вячеслав Лойе. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isDeteil) {
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.buttonSave.alpha = 0;
//        self.datePicker.date = self.eventDate;
        [self performSelector:@selector(setDatePickerValueWhitAnimation) withObject:nil afterDelay:0.5];
        
    } else {
    
    self.buttonSave.userInteractionEnabled = NO;
    
    self.datePicker.minimumDate = [NSDate date];
    
    [self.datePicker addTarget: self action:@selector(dataPickerValueChanged) forControlEvents: UIControlEventValueChanged];
    [self.buttonSave addTarget: self action:@selector(save) forControlEvents: UIControlEventTouchUpInside];
    UITapGestureRecognizer *hadleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleEndEditing)];
    [self.view addGestureRecognizer:hadleTap];
    }
}

-(void) setDatePickerValueWhitAnimation {
    [self.datePicker setDate:self.eventDate animated:YES];
    
}

-(void) dataPickerValueChanged {
    
    self.eventDate = self.datePicker.date;
    NSLog(@"Date Picker %@", self.datePicker.date);
}

-(void) handleEndEditing {
    // базовый метод по тапу на вью для закрытия textField
        
        if ([self.textField.text length] != 0) {
            [self.textField resignFirstResponder];
            self.buttonSave.userInteractionEnabled = YES;
            
        } else  {
            [self showAlertWithMessage:@"Для сохраненние события введите значение в текстовое поле"];
        }
}


-(void) save {
    if (self.eventDate) {
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlertWithMessage:@"Дата будущего события не может совпадать с текущей датой "];
        }
        else if ([self.eventDate compare: [NSDate date]] == NSOrderedAscending) {
            [self showAlertWithMessage:@"Дата будущего события не может быть ранее текущей даты"];
        } else {
            [self setNotification];
        }
        
    } else {
        [self showAlertWithMessage:@"Для сохраненние события измените значение даты на более позднее "];
    }
}

-(void) setNotification {
    NSString *eventInfo = self.textField.text;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"HH:mm dd.MMMM.yyyy";
    NSString *eventDate = [formater stringFromDate:self.eventDate];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          eventInfo, @"eventInfo",
                          eventDate, @"eventDate", nil];
    
    UILocalNotification *notification = [[UILocalNotification alloc
                                          ] init];
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"save");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.textField]) {
        
        if ([self.textField.text length] != 0) {
            [self.textField resignFirstResponder];
            self.buttonSave.userInteractionEnabled = YES;
            return YES;
            
        } else  {
            [self showAlertWithMessage:@"Для сохраненние события введите значение в текстовое поле"];
        }
        
    }
    return NO;
}

// лучше выносить метод showAlertWithMessage отдельно что бы переиспользовать

-(void) showAlertWithMessage : (NSString *)  message {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Внимание!" message: message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

@end
