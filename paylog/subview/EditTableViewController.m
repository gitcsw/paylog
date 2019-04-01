//
//  EditTableViewController.m
//  paylog
//
//  Created by Cooking singular wings on 2017/7/19.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "EditTableViewController.h"
#import "EditTableViewCell.h"
#import "TLTagsControl.h"
#import "CustomDefine.h"
#import "Consts.h"
#import "Whole.h"

@interface EditTableViewController ()<TLTagsControlDelegate>
@property (strong, nonatomic) IBOutlet UITableView *edittbv;
@property(nonatomic,strong)UIView * headerView;//tableView的头视图
@property(nonatomic, strong) NSArray *titles;
@property(nonatomic, strong) NSArray *placeHolders;
@property(nonatomic, weak) UITextField *nameTextField;
@property(nonatomic, weak) UITextField *timeTextField;
@property(nonatomic, weak) UITextField *typeTextField;
@property(nonatomic, weak) UITextField *moreTextField;
@property(nonatomic, weak) UITextField *moneyTextField;
@property(strong, nonatomic) TLTagsControl *cswtag;
@property(strong, nonatomic) TLTagsControl *ctptag;
@end

@implementation EditTableViewController
//
NSInteger taga,tagb;
bool aa;
UISwitch *cswitch;
float zjbc = 0;//中间保存数据
//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edittbv.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)headerView{
    if (!_headerView) {
         _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];//100
        NSMutableArray *tags = [NSMutableArray arrayWithArray:[Whole gettype2]];
        NSMutableArray *taggs = [NSMutableArray arrayWithArray:[Whole gettype]];
        NSMutableArray *taggb = [NSMutableArray arrayWithCapacity:taggs.count];
        for(int i = 0;i< taggs.count;i++)
        {
            NSString *abc = [[taggs objectAtIndex:i] objectForKey:@"name"];
            [taggb addObject:abc];
        }
//        UIButton *btncamera = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 35, 35)];
//        [btncamera setBackgroundImage:[UIImage imageNamed:@"btn_item_camera"] forState:UIControlStateNormal];
//        [btncamera addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
        //
        _cswtag = [[TLTagsControl alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 35)];
        _ctptag = [[TLTagsControl alloc] initWithFrame:CGRectMake(5, 55, SCREEN_WIDTH-10, 35)];
        _cswtag.tags = [tags mutableCopy];
        _cswtag.mode = TLTagsControlModeList;
        _cswtag.tagsBackgroundColor = SELECT_COLOR(75, 186, 251, 1);
        _cswtag.tagsTextColor = [UIColor whiteColor];
        [_cswtag reloadTagSubviews];
        [_cswtag setTapDelegate:self];
        //
        _ctptag.tags = [taggb mutableCopy];
        _ctptag.mode = TLTagsControlModeList;
        _ctptag.tagsBackgroundColor = SELECT_COLOR(75, 186, 251, 1);
        _ctptag.tagsTextColor = [UIColor whiteColor];
        [_ctptag reloadTagSubviews];
        [_ctptag setTapDelegate:self];
        taga = _cswtag.hash;
        tagb = _ctptag.hash;
        
        //[_headerView addSubview:btncamera];
        [_headerView addSubview:_cswtag];
        [_headerView addSubview:_ctptag];
    }
    return _headerView;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < 4)
    {
        if(indexPath.row == 1)
        {
            EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cswcell2"];
            cswitch = (UISwitch *) [cell viewWithTag:1];
            self.moneyTextField = cell.contentTextField;
            return cell;
        }
        else if(indexPath.row == 2)
        {
            EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cswcelltype"];
            self.timeTextField = cell.contentTextField;
            return cell;
        }
        else if(indexPath.row == 3)
        {
            EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cswcelltype"];
            self.typeTextField = cell.contentTextField;
            return cell;
        }
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cswcell1"];
        switch (indexPath.row)
        {
            case 0:
                self.nameTextField = cell.contentTextField;
                break;
            case 2:
                self.timeTextField = cell.contentTextField;
                break;
            default:
                break;
        }
        return cell;
    }
    else
    {
        EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cswcell3"];
        self.moreTextField = (UITextField*)cell.moretxt;
        //[self.moreTextField setText:cell.moretxt.text];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 200;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath//tableview加载cell
{
    EditTableViewCell *customCell = (EditTableViewCell *)cell;
    customCell.titleLabel.text = self.titles[indexPath.row];
    customCell.contentTextField.placeholder = self.placeHolders[indexPath.row];
    if (self.indexPath != nil)
    {
        self.navigationItem.title = NSLocalizedString(@"editem", @"");
        Consts *cc = self.consts[self.indexPath.row];
        self.nameTextField.text = cc.name;
        self.timeTextField.text = cc.time;
        self.typeTextField.text = cc.cswtype;
        self.moneyTextField.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.2f",cc.money.floatValue]];
        zjbc = cc.money.floatValue;
        //
        NSString *cst = self.moneyTextField.text;
        //NSLog(@"%@", cst);
        if([[cst substringToIndex:1]  isEqual: @"-"])
        {
            [cswitch setOn:NO];
            self.moneyTextField.text = [cst substringFromIndex:1];
        }
        else
        {
            [cswitch setOn:YES];
        }
        //
        self.moreTextField.text = cc.more;
    }
    else
    {
        NSDate *date=[NSDate date];//获取当前时间
        NSDateFormatter *format1=[[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        self.timeTextField.text = [format1 stringFromDate:date];
        zjbc = 0;
    }
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index{
    if(tagsControl.hash == taga)
    {
        if(index < 6)
            self.nameTextField.text = tagsControl.tags[index];
        else
        {
            if([self.moreTextField.text  isEqual: @" "])
                self.moreTextField.text = tagsControl.tags[index];
            else
                self.moreTextField.text = [NSString stringWithFormat:@"%@ %@", self.moreTextField.text, tagsControl.tags[index]];
        }
    }
    else if(tagsControl.hash == tagb)
        self.typeTextField.text = tagsControl.tags[index];
    else
        NSLog(@"?");
}

#pragma mark - private method
- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[NSLocalizedString(@"title", @""),NSLocalizedString(@"money", @""),
            NSLocalizedString(@"time", @""),
            NSLocalizedString(@"type", @""),
            NSLocalizedString(@"remark", @"")];
    }
    return _titles;
}

- (NSArray *)placeHolders
{
    if (!_placeHolders) {
        _placeHolders = @[NSLocalizedString(@"input1", @""),
                          NSLocalizedString(@"input2", @""),
                          NSLocalizedString(@"input3", @""),
                          NSLocalizedString(@"input4", @""),
                          NSLocalizedString(@"input5", @"")];
    }
    return _placeHolders;
}
- (IBAction)isdone:(id)sender {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserType.plist"];
    NSMutableArray *usersDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSString *theend;
    if ([self checkInput]==NO) {
        return;
    }
    //
    BOOL isButtonOn = [cswitch isOn];
    if (!isButtonOn)
    {
        self.moneyTextField.text = [NSString stringWithFormat:@"-%@",self.moneyTextField.text];
    }
    //封装
    Consts *s;
    if(self.indexPath==nil){
        s=[NSEntityDescription insertNewObjectForEntityForName:@"Consts" inManagedObjectContext:self.context];
        NSLog(@"%@",s);
        [self.consts addObject:s];
    }else{
        s=self.consts[self.indexPath.row];
    }
    s.name = self.nameTextField.text;
    s.time = self.timeTextField.text;
    s.cswtype = self.typeTextField.text;
    s.money = [NSNumber numberWithFloat:[self.moneyTextField.text floatValue]];
    s.more = self.moreTextField.text;
    //类型值修改
    for(int i = 0;i<usersDic.count;i++)
    {
        NSMutableDictionary *dic = [usersDic objectAtIndex:i];
        NSString *abc = [dic valueForKey:@"name"];
        if([abc isEqual: self.typeTextField.text])
        {
            NSString *jg = [dic valueForKey:@"money"];
            //计算
            theend = [NSString stringWithFormat:@"%.2f",[self.moneyTextField.text floatValue] + [jg floatValue] - zjbc];
            //NSLog(@"%.2f",zjbc);
            //修改
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:abc forKey:@"name"];
            [dic setObject:theend forKey:@"money"];
            [usersDic setObject:dic atIndexedSubscript:i];
            //NSLog(@"%@", usersDic);
            [Whole settp:usersDic];
            [usersDic writeToFile:plistPath atomically:YES];
            break;
        }
    }
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"出错：%@",error);
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) checkInput{
    NSString *value_score = [self.moneyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if (value_score.length != 0) {
        if ([value_score rangeOfString:@"."].location != NSNotFound&&value_score.length == 1) {
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请输入合法的数字！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    else
        return YES;
}

- (void)btnAction:(UIButton *)bt{
    NSLog(@"点击了camera");
}
@end
