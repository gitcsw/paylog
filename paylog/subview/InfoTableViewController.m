//
//  InfoTableViewController.m
//  paylog
//
//  Created by Cooking singular wings on 2017/7/18.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "InfoTableViewController.h"
#import "CustomDefine.h"
#import "Consts.h"
#import "Whole.h"

@interface InfoTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *infotbv;
@property(nonatomic,strong)UIView * headerView;//tableView的头视图
@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_indexPath);
    self.infotbv.tableHeaderView = self.headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"收入",@"支出",@"转账",nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
        segmentedControl.frame = CGRectMake(30, 10,SCREEN_WIDTH - 60, 30);
        //这个是设置按下按钮时的颜色
        segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
        segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
        //下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,SELECT_COLOR(49, 148, 208, 1), NSForegroundColorAttributeName, nil, nil];
        
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        
        [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        //设置分段控件点击相应事件
        [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
        
        [_headerView addSubview:segmentedControl];
    }
    return _headerView;
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"%ld",(long)Index);
//    switch (Index)
//    {
//        case 0:
//            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_apple_small.png")]];
//            break;
//        case 1:
//            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_orange_small.png")]];
//            break;
//        case 2:
//            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kSrcName(@"bg_banana_small.png")]];
//            break;
//        default:
//            break;
//    }
}
@end
