//
//  MainTableViewController.m
//  paylog
//
//  Created by GitCsw on 2017/7/17.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "MainTableViewController.h"
#import "ConstCoreDataProperties.h"
#import "EditViewController.h"
#import <Photos/Photos.h>
#import "CustomDefine.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "Whole.h"

@interface MainTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *morebtn;
@property (weak, nonatomic) IBOutlet UITableView *tablemsg;
//
@property(nonatomic,strong)UISearchController *searchController;
@property(strong,nonatomic)NSManagedObjectContext *context;
@property(strong,nonatomic)NSMutableArray *consts;
@property(strong,nonatomic)NSMutableArray *searchList;//筛选后数据
@property(strong,nonatomic)Consts *cconst;
//@property(strong,nonatomic)UIDocumentInteractionController *documentController;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _morebtn.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"more", @"")];
    self.title = [NSString stringWithFormat:@"%@",NSLocalizedString(@"item", @"")];
    [self loadsellor];
    [self addReafresh];//刷新控件
    [self typedatacreating];//类型数据加载
    PHAssetCollection *paylog = [self createCollection];
    [Whole setal:paylog];
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q, ^{
        [self.consts removeAllObjects];
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];});
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadsellor{
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = false;
    //搜索栏表头视图
    self.tablemsg.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.barTintColor = SELECT_COLOR(239, 239, 244, 1);
    self.searchController.searchBar.tintColor = [UIColor orangeColor];
    self.searchController.searchResultsUpdater = self;
}

-(void)typedatacreating{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserType.plist"];
    NSString *tagPath = [documentsPath stringByAppendingPathComponent:@"UserTag.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:plistPath])
    {
        NSMutableArray *defaulttags = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"alipay", @""), NSLocalizedString(@"tenpay", @""), NSLocalizedString(@"crcard", @""), NSLocalizedString(@"cicard", @""),
            NSLocalizedString(@"apppay", @""),
            NSLocalizedString(@"cash", @""),
            NSLocalizedString(@"others", @"")]];
        //NSMutableArray *defaulttags = [NSMutableArray arrayWithArray:@[@"支付宝", @"现金", @"校园卡", @"财付通", @"银行卡", @"杭州通",@"宁波公交卡", @"其他"]];
        NSMutableArray *usersArray = [[NSMutableArray alloc ] init];
        for(int i = 0;i<defaulttags.count;i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[defaulttags objectAtIndex:i] forKey:@"name"];
            [dic setObject:@"0.00" forKey:@"money"];
            [usersArray addObject:dic];
        }
        //写入文件
        [usersArray writeToFile:plistPath atomically:YES];
        [Whole settp:usersArray];
        NSLog(@"路径:%@\n内容:%@",plistPath,usersArray);
    }
    else
    {
        NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        [Whole settp:data];
        NSLog(@"路径%@",plistPath);
    }
    //
    //NSMutableArray *tags = [NSMutableArray arrayWithArray:@[@"早饭", @"午饭", @"晚饭", @"路费", @"外卖", @"商店",@"东和食堂", @"西和食堂", @"校内听松食堂", @"东和生活区", @"西和生活区", @"校内", @"科院小店"]];
    //[Whole settp2:tags];//暂时预留，以后存在本地磁盘
    //
    if(![fileManager fileExistsAtPath:tagPath])
    {
        NSMutableArray *defaulttags = [NSMutableArray arrayWithArray:@[NSLocalizedString(@"breakfast", @""), NSLocalizedString(@"lunch", @""), NSLocalizedString(@"dinner", @""), NSLocalizedString(@"traexp", @""),
            NSLocalizedString(@"takeout", @""),
            NSLocalizedString(@"restaurant", @""),
            NSLocalizedString(@"inhome", @"")]];
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        for(int i = 0;i<defaulttags.count;i++)
        {
            NSString *dic = [defaulttags objectAtIndex:i];
            [usersArray addObject:dic];
        }
        //写入文件
        [usersArray writeToFile:tagPath atomically:YES];
        [Whole settp2:usersArray];
    }
    else
    {
        NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:tagPath];
        [Whole settp2:data];
    }
}
//
-(NSManagedObjectContext*)context//数据子函数1
{
    if (!_context) {
        AppDelegate *coreDataManager = [[AppDelegate alloc]init];
        _context = [coreDataManager managedObjectContext];
    }
    return _context;
}
-(NSArray *)queryData:(NSString *)entityname sortWith:(NSString*)sortDesc ascending:(BOOL)asc predicateString:(NSString*)ps//数据子函数2
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.fetchLimit = 1000;//最大数量 csw
    request.fetchBatchSize = 20;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortDesc ascending:asc]];
    if (ps) {
        request.predicate = [NSPredicate predicateWithFormat:@"名称包含(name contains)%@",ps];
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityname inManagedObjectContext:self.context];
    request.entity = entity;
    NSError *error;
    NSArray *arrs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"无法获取数据，%@",error);
    }
    return arrs;
}
-(void)loadData//加载数据
{
    NSArray *a = [self queryData:@"Consts" sortWith:@"time" ascending:YES predicateString:nil];
    _consts = [NSMutableArray array];
    float aa = 0;
    int bb = (int)a.count;
    for (Consts *s in a) {
        aa = [s.money floatValue] + aa;
        [_consts addObject:s];
    }
    [Whole setStr:aa];
    [Whole setNum:bb];
    //printf("money is:%f,ave is:%d",aa,bb);//test
    a = [[_consts reverseObjectEnumerator] allObjects];//倒叙数组
    _consts = [a mutableCopy];//或者_consts = a;但是有警告
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNew"]) {
        if ([segue.destinationViewController isKindOfClass:[EditViewController class]]) {
            EditViewController *vc = (EditViewController *)segue.destinationViewController;
            vc.consts = self.consts;
            vc.indexPath = nil;
            vc.context=self.context;
            vc.navigationItem.title = NSLocalizedString(@"addnew", @"");
        }
    }
    else
    {
        if ([segue.destinationViewController isKindOfClass:[EditViewController class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            EditViewController *vc = (EditViewController *)segue.destinationViewController;
            vc.consts = self.consts;
            vc.context=self.context;
            vc.indexPath = indexPath;
            vc.navigationItem.title = NSLocalizedString(@"detail", @"");
        }
    }
}

-(NSMutableArray*)consts//数据加载入口
{
    if (!_consts) {
        [self loadData];
        [Whole setsj:_consts];
    }
    return _consts;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.consts.count;
}
//插入表单元
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cinfo" forIndexPath:indexPath];
    //UIImageView *edit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    //edit.frame = CGRectMake(SCREEN_WIDTH - 42, 11, 22, 22);
    UILabel *mtype = (UILabel*)[cell viewWithTag:1];
    UILabel *ltype;
    if(mtype == nil)
    {
        ltype = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 11, SCREEN_WIDTH/2 - 48, 22)];
        ltype.textAlignment = NSTextAlignmentRight;
        //ltype.text = self.cconst.cswtype;
        [ltype setTag:1];
        [cell addSubview:ltype];
    }
    else
    {
        mtype.textAlignment = NSTextAlignmentRight;
        //[mtype setText:self.cconst.cswtype];
    }
    UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 42, 11, 22, 22)];
    [edit setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    edit.tag = [indexPath row];
    [edit addTarget:self action:@selector(btnedit:) forControlEvents:UIControlEventTouchDown];
    [cell addSubview:edit];
    self.cconst = self.consts[indexPath.row];//反复刷屏这会报错
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ¥%.2f",self.cconst.name,self.cconst.money.floatValue];
    cell.detailTextLabel.text = self.cconst.time;
    ltype.text = self.cconst.cswtype;
    mtype.text = self.cconst.cswtype;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.cconst.time,self.cconst.cswtype];
    //
    NSString *cst = [NSString stringWithFormat:@"%.2f",self.cconst.money.floatValue];
    if([[cst substringToIndex:1]  isEqual: @"-"])
        cell.imageView.image = [UIImage imageNamed:@"paymoney"];
    else
        cell.imageView.image = [UIImage imageNamed:@"getmoney"];
    return cell;
}
//删除表单元
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        @try{
        [self.context deleteObject:self.consts[indexPath.row]];
        [self.consts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *error;
        [self.context save:&error];
        }
        @catch(NSException * e){
            NSLog(@"Exception: %@", e);
            UIAlertView * alert =
            [[UIAlertView alloc]
             initWithTitle:@"错误"
             message: [[NSString alloc] initWithFormat:@"%@",e]
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
    }
}

- (void)addReafresh{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.header endRefreshing];
//        });
        dispatch_queue_t q =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(q, ^{
            [self.consts removeAllObjects];
            [self loadData];
            dispatch_async(dispatch_get_main_queue(), ^{[self.tableView reloadData];
            [self.tableView.header endRefreshing];
            });
        });
    }];
    self.tableView.header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.automaticallyChangeAlpha = YES;
    [header setTitle:NSLocalizedString(@"refreshup", @"") forState:MJRefreshStateRefreshing];
}

//cell中的编辑按钮点击事件
- (IBAction)btnedit:(UIButton *)sender {
    //NSLog(@"%ld",(long)sender.tag);
    NSUInteger indexs[] = {0, sender.tag};//定义并初始化一个C数组:2个元素
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexs length:2];
//    EditTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyView"];
//    vc.consts= self.consts;
//    vc.indexPath = indexPath;
//    vc.context = self.context;
//    [self.navigationController pushViewController:vc animated:YES];
    EditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyView"];
    vc.consts= self.consts;
    vc.indexPath = indexPath;
    vc.context = self.context;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchController
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    [self.consts removeAllObjects];//数组清空
//    NSArray *a = [self queryData:@"Consts" sortWith:@"time" ascending:YES predicateString:searchController.searchBar.text];
//    for(Consts *stu in a){
//        [self.consts addObject:stu];
//    }
//    [self.tableView reloadData];//刷新表格
}

//
//
// 创建自己要创建的自定义相册
- (PHAssetCollection * )createCollection{
    // 创建一个新的相册
    // 查看所有的自定义相册
    // 先查看是否有自己要创建的自定义相册
    // 如果没有自己要创建的自定义相册那么我们就进行创建
    //NSString * title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];//应用名称
    NSString *title = @"支记宝";
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection * createCollection = nil; // 最终要获取的自己创建的相册
    for (PHAssetCollection * collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {    // 如果有自己要创建的相册
            createCollection = collection;
            break;
        }
    }
    if (createCollection == nil) {  // 如果没有自己要创建的相册
        // 创建自己要创建的相册
        NSError * error1 = nil;
        __block NSString * createCollectionID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString *title = @"支记宝";
            createCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error1];
        
        if (error1) {
            NSLog(@"创建相册失败...");
            return nil;
        }
        // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createCollectionID] options:nil].firstObject;
    }
    
    return createCollection;
}
@end
