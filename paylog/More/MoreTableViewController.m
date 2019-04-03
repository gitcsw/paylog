//
//  MoreTableViewController.m
//  paylog
//
//  Created by GitCsw on 2017/8/27.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "MoreTableViewController.h"
#import "TyptagTViewController.h"
#import "ToptagTViewController.h"
#import "DeTViewController.h"

@interface MoreTableViewController ()
{
    NSArray *dataSource,*dataSource2;
    float s;
    int b;
}

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    s = [Whole getStr];
    b = [Whole getNum];
    dataSource=@[@"数据导入",@"数据导出",@"标签设置",@"类型编辑"];
    dataSource2=@[@"启动密码/指纹设置",@"应用支持"];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 4;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 1;
    else if (section==1)
        return dataSource.count;
    else if(section==2)
        return dataSource2.count;
    else
        return 1;
}
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 20;
    }
    return 20;
}
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 66;
    }
    return 44;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cswcell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    if (indexPath.section==0)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"constsinfo"];
        
        //
        UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 8, 300, 21)];
        UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 36, 300, 21)];
        //aLabel.text = @"至今共消费了：1000,0000,0000.00 元";
        //bLabel.text = @"总共记录了：    1000,0000,0000 笔";
        aLabel.text = [NSString stringWithFormat:@"至今金额总和：%@ 元",[NSString stringWithFormat:@"%.2f",s]];
        bLabel.text = [NSString stringWithFormat:@"总共记录了：   %@ 笔",[NSString stringWithFormat:@"%d",b]];
        //
        [cell.contentView addSubview:aLabel];
        [cell.contentView addSubview:bLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text=[dataSource objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.section == 2)
    {
        cell.textLabel.text=[dataSource2 objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else
    {
        cell.textLabel.text=@"支记宝 ©GitCsw v.20171119";
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    return cell;
}

//点击事件
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"yesa,%@",indexPath);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*NSLog(@"yes,%@",indexPath);
     [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中*/
    if(indexPath.section == 0)
    {
        
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
//                diViewController *va = [self.storyboard instantiateViewControllerWithIdentifier:@"cdataim"];
//                va.title = @"数据导入";
//                [self.navigationController pushViewController:va animated:YES];
                break;
            }
            case 1:
            {
                DeTViewController *va = [self.storyboard instantiateViewControllerWithIdentifier:@"cdataex"];
                va.title = @"数据导出";
                [self.navigationController pushViewController:va animated:YES];
                break;
            }
            case 2:
            {
                ToptagTViewController *va = [self.storyboard instantiateViewControllerWithIdentifier:@"cswtp"];
                va.title = @"类型编辑";
                [self.navigationController pushViewController:va animated:YES];

                break;
            }
            case 3:
            {
                TyptagTViewController *va = [self.storyboard instantiateViewControllerWithIdentifier:@"cswty"];
                va.title = @"类型编辑";
                [self.navigationController pushViewController:va animated:YES];
                break;
            }
            default:
                break;
        }
    }
    else if(indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
//                cpViewController *va = [self.storyboard instantiateViewControllerWithIdentifier:@"cprotect"];
//                va.title = @"密码指纹设置";
//                [self.navigationController pushViewController:va animated:YES];
                break;
            }
            case 1:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/gitcsw/paylog"]];
                break;
            default:
                break;
        }
    }
    else
    {
//        AboutViewController *aView = [self.storyboard instantiateViewControllerWithIdentifier:@"cswab"];
//        aView.title = @"关于\"支记宝\"";
//        [self.navigationController pushViewController:aView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
