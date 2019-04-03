//
//  ToptagTViewController.m
//  paylog
//
//  Created by GitCsw on 2017/8/30.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "ToptagTViewController.h"

@interface ToptagTViewController ()
{
    CGSize csize;
    NSString *plistPath;
    //NSString *infoDic;
    NSMutableArray *tpdata;
    NSMutableArray *usersDic;
}

@end

@implementation ToptagTViewController

- (void)viewDidLoad {
    CGRect rect = [[UIScreen mainScreen] bounds];
    csize = rect.size;
    tpdata = [Whole gettype2];
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addtype)];
    //
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    plistPath = [documentsPath stringByAppendingPathComponent:@"UserTag.plist"];
    usersDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{//刷新
    tpdata = [Whole gettype2];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tpdata.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"top";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    //
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tpinfo"];
    
    //
    cell.textLabel.text = [tpdata objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

//删除表单元
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"将会删除此标签，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
        //添加按钮
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确定按钮");
            [tpdata removeObjectAtIndex:indexPath.row];
            [usersDic removeObjectAtIndex:indexPath.row];
            [Whole settp2:usersDic];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [usersDic writeToFile:plistPath atomically:YES];
        }];//UIAlertActionStyleDestructive
        
        [alert addAction:action];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消按钮");
        }]];
        [self presentViewController:alert animated:nil completion:nil];
    }
}

-(void)addtype{
    if(!self.tableView.editing)
    {
        BOOL flag = !self.tableView.editing;
        [self.tableView setEditing:flag animated:YES];
    }
    else{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"新建类型" preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL flag = !self.tableView.editing;
        [self.tableView setEditing:flag animated:YES];
    }]];
    //增加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第输入框内容
        NSString *new= @"";
        UITextField *NameTextField = alertController.textFields.firstObject;
        new = NameTextField.text;
        [tpdata addObject:new];
        [usersDic addObject:new];
        [Whole settp2:usersDic];
        [usersDic writeToFile:plistPath atomically:YES];
        [self.tableView reloadData];
    }]];
    //定义一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入类型名称";
        //textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertController animated:true completion:nil];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}

#pragma mark 排序 当移动了某一行时候会调用
//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // 取出要拖动的模型数据
    NSString *qc = tpdata[sourceIndexPath.row];
    //删除之前行的数据
    [tpdata removeObjectAtIndex:sourceIndexPath.row];
    // 插入数据到新的位置
    [tpdata insertObject:qc atIndex:destinationIndexPath.row];
    [Whole settp2:tpdata];
    [tpdata writeToFile:plistPath atomically:YES];
}
@end
