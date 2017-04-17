//
//  ViewController.m
//  CoreDATA
//
//  Created by Student P_04 on 17/04/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTable.delegate=self;
    self.myTable.dataSource=self;
    self.searchText.delegate=self;
    [self fetchRequest];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchRequest
{
    NSError *error;
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.context=delegate.persistentContainer.viewContext;
    NSEntityDescription *myEntity=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Item"];
    [fetchRequest setEntity:myEntity];
    if(self.searchText.text.length>0)
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"itemName contains[cd] %@",self.searchText.text];
        [fetchRequest setPredicate:predicate];
        
    }
    self.itemArray=[self.context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *myObject;
    if(self.itemArray.count!=0)
    {
        myObject=[self.itemArray firstObject];
        self.itemNameText.text=[myObject valueForKey:@"itemName"];
        id rate=[myObject valueForKey:@"itemRate"];
        self.itemRateText.text=[NSString stringWithFormat:@"%@",rate];
        
    }
    self.itemNameArray=[self.itemArray valueForKey:@"itemName"];
    self.itemRateArray=[self.itemArray valueForKey:@"itemRate"];
    NSLog(@"%@",self.itemNameArray);
    NSLog(@"%@",self.itemRateArray);
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.myTable reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text=[self.itemNameArray objectAtIndex:indexPath.row];
    id rateVlaue=[NSString stringWithFormat:@"%@",[self.itemRateArray objectAtIndex:indexPath.row]];
    NSString *rate=rateVlaue;
    cell.detailTextLabel.text=rate;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    self.itemNameText.text=cell.textLabel.text;
    self.itemRateText.text=cell.detailTextLabel.text;
    self.searchText.text=cell.textLabel.text;
    //[self fetchRequest];
    [self.myTable reloadData];
}
-(void)insertObject
{
    NSEntityDescription *myEntity=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
    NSManagedObject *newObject=[[NSManagedObject alloc]initWithEntity:myEntity insertIntoManagedObjectContext:self.context];
    [newObject setValue:self.itemNameText.text forKey:@"itemName"];
    NSNumberFormatter *f=[[NSNumberFormatter alloc]init];
    f.numberStyle=NSNumberFormatterDecimalStyle;
    NSNumber *myNumber=[f numberFromString:self.itemRateText.text];
    [newObject setValue:myNumber forKey:@"itemRate"];
    NSError *error;
    [self.context save:&error];
    if(error)
    {
        NSLog(@"%@",error.localizedDescription);
    }
    else
    {
        NSLog(@"Insertion success");
    }
    
}
-(bool)textFieldShouldReturn:(UITextField *)textField
{
    [self fetchRequest];
    [self.myTable reloadData];
    return true;
}
-(void)deleteObject
{
    NSError *error;
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.context=delegate.persistentContainer.viewContext;
    NSEntityDescription *myEntity=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Item"];
    [fetchRequest setEntity:myEntity];
    if(self.searchText.text.length>0)
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"itemName contains[cd] %@",self.searchText.text];
        [fetchRequest setPredicate:predicate];
        
    }
    self.itemArray=[self.context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *myObject;
    if(self.itemArray.count>0)
    {
        myObject=[self.itemArray firstObject];
        [self.context deleteObject:myObject];
        if(![self.context save:&error])
        {
            NSLog(@"Delete failed");
            
        }
        NSLog(@"%@",error.localizedDescription);
    }
    NSLog(@"Delete success:");
}
-(void)updateObject
{
    NSError *error;
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    self.context=delegate.persistentContainer.viewContext;
    NSEntityDescription *myEntity=[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
    
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Item"];
    [fetchRequest setEntity:myEntity];
    if(self.searchText.text.length>0)
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"itemName contains[cd] %@",self.searchText.text];
        [fetchRequest setPredicate:predicate];
        
    }
    self.itemArray=[self.context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *myObject;
    if(self.itemArray.count==1)
    {
        myObject=[self.itemArray firstObject];
        [myObject setValue:self.itemNameText.text forKey:@"itemName"];
        
        NSNumberFormatter *f=[[NSNumberFormatter alloc]init];
        f.numberStyle=NSNumberFormatterDecimalStyle;
        NSNumber *myNumber=[f numberFromString:self.itemRateText.text];
        [myObject setValue:myNumber forKey:@"itemRate"];
        [self.context save:&error];
        
        if(error)
        {
            NSLog(@"%@",error.localizedDescription);
        }
        else
        {
            NSLog(@"Update Success");
        }
        
    }
}
- (IBAction)insertButton:(id)sender
{
    [self insertObject];
    [self fetchRequest];
    [self.myTable reloadData];
    self.itemRateText.text=@"";
    self.itemRateText.text=@"";
}

- (IBAction)updateButton:(id)sender
{
    [self updateObject];
    [self fetchRequest];
    [self.myTable reloadData];
}

- (IBAction)deleteButton:(id)sender
{
    [self deleteObject];
    [self fetchRequest];
    [self.myTable reloadData];
    
}
@end
