//
//  DeTViewController.m
//  paylog
//
//  Created by GitCsw on 2017/8/27.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "DeTViewController.h"

@interface DeTViewController ()<UIDocumentInteractionControllerDelegate>
{
    CGSize size;
    NSString *sq,*sqw,*sqs,*ctp,*cto;
    NSArray *documentPaths;
    NSString *ourDocumentPath;
}
@property(strong,nonatomic)UIDocumentInteractionController *documentController;
@end

@implementation DeTViewController

- (void)viewDidLoad {
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    ourDocumentPath =[documentPaths objectAtIndex:0];
    //
    sqw =[NSString stringWithFormat:@"%.2fMB",[self fileSizeAtPath :@"XMpaylog.sqlite-wal"]/1048576];//1048576
    sq =[NSString stringWithFormat:@"%.1fKB",[self fileSizeAtPath :@"XMpaylog.sqlite"]/1024];
    sqs =[NSString stringWithFormat:@"%.1fKB",[self fileSizeAtPath :@"XMpaylog.sqlite-shm"]/1024];
    ctp =[NSString stringWithFormat:@"%.1fKB",[self fileSizeAtPath :@"UserType.plist"]/1024];
    cto =[NSString stringWithFormat:@"%.1fKB",[self fileSizeAtPath :@"UserTag.plist"]/1024];
    CGRect rect = [[UIScreen mainScreen] bounds];
    size = rect.size;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (double) fileSizeAtPath:(NSString*) fname{
    NSString *filePath=[ourDocumentPath stringByAppendingPathComponent:fname];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 5;
    else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"lalala";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    if(indexPath.section == 0){
        if (indexPath.row == 0)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
            
            //
            UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 300, 21)];
            UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(size.width - 80, 11, 70, 21)];
            //bLabel.textColor =
            aLabel.text = @"数据描述文件(sqlite)";
            bLabel.text = sq;
            [cell.contentView addSubview:aLabel];
            [cell.contentView addSubview:bLabel];
        }
        else if(indexPath.row == 1)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
            
            //
            UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 300, 21)];
            UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(size.width - 80, 11, 70, 21)];
            //bLabel.textColor =
            aLabel.text = @"数据存储文件(sqlite-wal)";
            bLabel.text = sqw;
            [cell.contentView addSubview:aLabel];
            [cell.contentView addSubview:bLabel];
        }
        else if(indexPath.row == 2)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
            
            //
            UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 300, 21)];
            UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(size.width - 80, 11, 70, 21)];
            //bLabel.textColor =
            aLabel.text = @"数据辅助文件(sqlite-shm)";
            bLabel.text = sqs;
            [cell.contentView addSubview:aLabel];
            [cell.contentView addSubview:bLabel];
        }
        else if(indexPath.row == 3)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
            
            //
            UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 300, 21)];
            UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(size.width - 80, 11, 70, 21)];
            //bLabel.textColor =
            aLabel.text = @"自定义类型标签(Type)";
            bLabel.text = sqs;
            [cell.contentView addSubview:aLabel];
            [cell.contentView addSubview:bLabel];
        }
        else
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
            
            //
            UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 300, 21)];
            UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(size.width - 80, 11, 70, 21)];
            //bLabel.textColor =
            aLabel.text = @"自定义标题标签(Title)";
            bLabel.text = sqs;
            [cell.contentView addSubview:aLabel];
            [cell.contentView addSubview:bLabel];
        }
    }
    else
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"csqlite"];
        cell.textLabel.text=@"清除数据";
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    return cell;
}

-(void)geiqitayydk:(NSString*) wjm{
    NSString *filePath=[ourDocumentPath stringByAppendingPathComponent:wjm];
    if(filePath)
    {
        _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        //设置代理
        _documentController.delegate = self;
        BOOL canOpen = [_documentController presentOpenInMenuFromRect:CGRectZero
                                                               inView:self.view
                                                             animated:YES];
        if (!canOpen) {
            NSLog(@"没有程序能够打开这个文件");
        }
    }
    else
        printf("not found");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
            [self geiqitayydk :@"XMpaylog.sqlite"];
        else if(indexPath.row == 1)
            [self geiqitayydk :@"XMpaylog.sqlite-wal"];
        else if(indexPath.row == 2)
            [self geiqitayydk :@"XMpaylog.sqlite-shm"];
        else if(indexPath.row == 3)
            [self geiqitayydk :@"UserType.plist"];
        else
            [self geiqitayydk :@"UserTag.plist"];
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"支记宝" message:@"是否清除数据(不包括plist文件)？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
        [alertview show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
