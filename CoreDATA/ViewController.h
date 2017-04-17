//
//  ViewController.h
//  CoreDATA
//
//  Created by Student P_04 on 17/04/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)insertButton:(id)sender;
- (IBAction)updateButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *itemNameText;
@property (weak, nonatomic) IBOutlet UITextField *itemRateText;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property NSArray *itemArray;
@property NSArray *itemNameArray;
@property NSArray *itemRateArray;
@property NSManagedObjectContext *context;
@end

