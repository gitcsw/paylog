//
//  EditViewController.m
//  paylog
//
//  Created by GitCsw on 2017/8/14.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "EditViewController.h"
//
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "CswPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

@interface EditViewController()<TLTagsControlDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSArray *_sourcedata;
    BOOL _isSelectOriginalPhoto;
    BOOL _keyboardIsVisible;
    BOOL _isget;
    CGFloat _itemWH;
    CGFloat _margin;
    NSString *sj;
    NSString *pd;
    NSString *pic;
    NSInteger atag,btag;
    float zjbc;
}
@property (weak, nonatomic) IBOutlet UIScrollView *infousv;
@property (weak, nonatomic) IBOutlet UIView *buttomv;
//
@property(strong, nonatomic) UILabel *bti;
@property(strong, nonatomic) UITextField *ctitle;
@property(strong, nonatomic) UITextField *cmoney;
@property(strong, nonatomic) NSString *cmoneyns;
@property(strong, nonatomic) UITextField *ctype;
@property(strong, nonatomic) UITextField *ctime;
@property(strong, nonatomic) UITextField *ctimediy;
@property(strong, nonatomic) UITextView *cmore;
@property(strong, nonatomic) TLTagsControl *cswtag;
@property(strong, nonatomic) TLTagsControl *ctptag;
@property(strong, nonatomic) UISegmentedControl *segmentedControl;
//
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation EditViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //_infousv.contentSize=CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT-163);
    _infousv.showsHorizontalScrollIndicator = FALSE;
    _cmoneyns = @"0";
    sj = @"0";
    pd = @"$ 0.00";
    zjbc = 0;
    [self initaddview];
    [self configCollectionView];
    [self initbuttomview];
    [self initdata];
    self.infousv.delegate = self;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide)  name:UIKeyboardWillHideNotification object:nil];
    _keyboardIsVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initaddview{
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[Whole gettype2]];
    NSMutableArray *taggs = [NSMutableArray arrayWithArray:[Whole gettype]];
    NSMutableArray *taggb = [NSMutableArray arrayWithCapacity:taggs.count];
    for(int i = 0;i< taggs.count;i++)
    {
        NSString *abc = [[taggs objectAtIndex:i] objectForKey:@"name"];
        [taggb addObject:abc];
    }
    //view
    _bti = [[UILabel alloc] initWithFrame:CGRectMake(50, 42, SCREEN_WIDTH/2-55, 15)];
    _bti.text = NSLocalizedString(@"titlrk", @"");
    _bti.font = [UIFont systemFontOfSize:13];
    _bti.textColor = [UIColor grayColor];
    UIImageView *tilogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titlelogo"]];
    tilogo.frame = CGRectMake(15, 20, 30, 40);
    _ctitle = [[UITextField alloc] initWithFrame:CGRectMake(50, 20, SCREEN_WIDTH/2-55, 20)];
    _ctitle.placeholder = NSLocalizedString(@"ttitle", @"");
    _ctitle.font = [UIFont systemFontOfSize:20];
    _cmoney = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+1, 20, SCREEN_WIDTH/2-16, 40)];
    _cmoney.text = @"¥ 0.00";
    _cmoney.font = [UIFont systemFontOfSize:30];
    _cmoney.textAlignment= NSTextAlignmentRight;
    _cmoney.textColor = SELECT_COLOR(0, 120, 0, 1);
    _cmoney.keyboardType = UIKeyboardTypeDecimalPad;
    [_cmoney addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _ctype = [[UITextField alloc] initWithFrame:CGRectMake(15, 130, 80, 35)];
    _ctype.placeholder = NSLocalizedString(@"ttype", @"");
    _ctype.font = [UIFont systemFontOfSize:16];
    _ctype.borderStyle = UITextBorderStyleRoundedRect;
    _ctime = [[UITextField alloc] initWithFrame:CGRectMake(15, 175, 140, 15)];
    _ctime.text = @"2017/09/10 12:00:00";
    _ctime.textColor = [UIColor grayColor];
    _ctime.font = [UIFont systemFontOfSize:14];
    _ctime.textAlignment= NSTextAlignmentCenter;
    _ctimediy = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 175, SCREEN_WIDTH/2 - 17, 15)];
    _ctimediy.text = @"Today";
    _ctimediy.textColor = [UIColor grayColor];
    _ctimediy.font = [UIFont systemFontOfSize:14];
    _ctimediy.textAlignment= NSTextAlignmentRight;
    _cmore = [[UITextView alloc] initWithFrame:CGRectMake(15, 205, SCREEN_WIDTH-30, 60)];
    _cmore.text = NSLocalizedString(@"morerk", @"");
    _cmore.font = [UIFont systemFontOfSize:15];
    _cmore.layer.borderWidth = 1;
    _cmore.layer.cornerRadius = 5;
//     UITextView * ctitle = [[UITextView alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH/2-35, 20)];
//    ctitle.text = @"12345";
//    ctitle.font = [UIFont systemFontOfSize:18.f];
    //line
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.25f, 15, 0.5f, 50)];
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(15, 75-0.25f, SCREEN_WIDTH-30, 0.5f)];
    UIView *line3=[[UIView alloc] initWithFrame:CGRectMake(15, 195-0.25f, SCREEN_WIDTH-30, 0.5f)];
    line1.backgroundColor = [UIColor grayColor];
    line2.backgroundColor = [UIColor grayColor];
    line3.backgroundColor = [UIColor grayColor];
    //TLTagsControl
    _cswtag = [[TLTagsControl alloc] initWithFrame:CGRectMake(15, 85, SCREEN_WIDTH-30, 35)];
    _ctptag = [[TLTagsControl alloc] initWithFrame:CGRectMake(100, 130, SCREEN_WIDTH-115, 35)];
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
    atag = _cswtag.hash;
    btag = _ctptag.hash;
    //
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[CswPhotoCell class] forCellWithReuseIdentifier:@"CswPhotoCell"];
    
    [_infousv addSubview:_bti];
    [_infousv addSubview:tilogo];
    [_infousv addSubview:_ctitle];
    [_infousv addSubview:_cmoney];
    [_infousv addSubview:_ctype];
    [_infousv addSubview:_ctime];
    [_infousv addSubview:_ctimediy];
    [_infousv addSubview:_cmore];
    [_infousv addSubview:line1];
    [_infousv addSubview:line2];
    [_infousv addSubview:line3];
    [_infousv addSubview:_cswtag];
    [_infousv addSubview:_ctptag];
}

-(void)initbuttomview{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"收入",@"支出",nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    _segmentedControl.frame = CGRectMake(40, 10,SCREEN_WIDTH - 80, 30);
    //这个是设置按下按钮时的颜色
    _segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
    _segmentedControl.selectedSegmentIndex = 1;//默认选中的按钮索引
    //下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,SELECT_COLOR(49, 148, 208, 1), NSForegroundColorAttributeName, nil, nil];
    
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
    
    [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    //设置分段控件点击相应事件
    [_segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    [_buttomv addSubview:_segmentedControl];
}

-(void)initdata{
    NSDate *nowDate = [NSDate date];
    if (self.indexPath != nil)
    {
        self.navigationItem.title = NSLocalizedString(@"editem", @"");
        Consts *cc = self.consts[self.indexPath.row];
        self.ctitle.text = cc.name;
        self.ctime.text = cc.time;
        _sourcedata = [NSArray arrayWithObjects:cc.cswtype,cc.money, nil];
        //时间计算
        _ctimediy.text = [self getTotalTimeWithStartTime:cc.time endTime:nowDate];
        //[self performSelector:@selector(getTotalTimeWithStartTime) withObject:cc.time withObject:nowDate];
        //时间计算结束
        self.ctype.text = cc.cswtype;
        self.cmoneyns = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.2f",cc.money.floatValue]];
        self.cmoney.text = [NSString stringWithFormat:@"¥ %@",_cmoneyns];
        //zjbc = cc.money.floatValue;
        //
        NSString *cst = self.cmoneyns;
        //NSLog(@"%@", cst);
        if([[cst substringToIndex:1]  isEqual: @"-"])
        {
            _segmentedControl.selectedSegmentIndex = 1;
            _isget = false;
            self.cmoneyns = [cst substringFromIndex:1];
            _cmoney.text = [NSString stringWithFormat:@"¥ %@",_cmoneyns];
        }
        else
        {
            _cmoney.textColor = [UIColor redColor];
            _segmentedControl.selectedSegmentIndex = 0;
            _isget = true;
        }
        //
        self.cmore.text = cc.more;
        //
        NSString *string =cc.picarray;
        NSArray *array = [string componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
        _selectedPhotos = [[NSMutableArray alloc]init];
        _selectedAssets = [[NSMutableArray alloc]init];
        [self enumerateAssetsInAssetCollection:[Whole getAlbumCollection] original:NO iseq:array];
    }
    else
    {
        NSDateFormatter *format1=[[NSDateFormatter alloc]init];
        [format1 setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        self.ctime.text = [format1 stringFromDate:nowDate];
        self.ctimediy.text = NSLocalizedString(@"now", @"");
        //zjbc = 0;
        self.ctype.text = @"其他";
    }
}

- (NSString *)getTotalTimeWithStartTime:(NSString *)startTime endTime:(NSDate *)endTime{
    //按照日期格式创建日期格式句柄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //将日期字符串转换成Date类型
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    //NSDate *startDate = startTime;
    NSDate *endDate = endTime;
    //NSDate *endDate = [dateFormatter dateFromString:endTime];
    //将日期转换成时间戳
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [endDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    //计算具体的天，时，分，秒
    int second = (int)value %60;//秒
    int minute = (int)value / 60 % 60;
    int hour = (int)value / 3600 % 24;
    int day = (int)value / (24 * 3600);
    //将获取的int数据重新转换成字符串
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d%@%d%@%d%@%d%@%@",day,NSLocalizedString(@"D", @""),hour,NSLocalizedString(@"H", @""),minute,NSLocalizedString(@"m", @""),second,NSLocalizedString(@"s", @""),NSLocalizedString(@"ago", @"")];
    }else if (day == 0 && hour != 0) {
        str = [NSString stringWithFormat:@"%d%@%d%@%d%@%@",hour,NSLocalizedString(@"H", @""),minute,NSLocalizedString(@"m", @""),second,NSLocalizedString(@"s", @""),NSLocalizedString(@"ago", @"")];
    }else if (day == 0 && hour == 0 && minute != 0) {
        str = [NSString stringWithFormat:@"%d%@%d%@%@",minute,NSLocalizedString(@"m", @""),second,NSLocalizedString(@"s", @""),NSLocalizedString(@"ago", @"")];
    }else{
        str = [NSString stringWithFormat:@"%d%@%@",second,NSLocalizedString(@"s", @""),NSLocalizedString(@"ago", @"")];
    }
    //返回string类型的总时长
    return str;
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"%ld",(long)Index);
    switch (Index)
    {
        case 0:
        {
            _isget = true;
            _cmoney.textColor = [UIColor redColor];
            break;
        }
        case 1:
        {
            _isget = false;
            _cmoney.textColor = SELECT_COLOR(0, 120, 0, 1);
            break;
        }
        default:
            break;
    }
}

#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index{
    if(tagsControl.hash == atag)
    {
        if(index < 6)
            self.ctitle.text = tagsControl.tags[index];
        else
        {
            if([self.cmore.text isEqual:NSLocalizedString(@"morerk", @"")])
                self.cmore.text = tagsControl.tags[index];
            else
                self.cmore.text = [NSString stringWithFormat:@"%@ %@", self.cmore.text, tagsControl.tags[index]];
        }
    }
    else if(tagsControl.hash == btag)
        self.ctype.text = tagsControl.tags[index];
    else
        NSLog(@"?");
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    //
    _margin = 3;
    _itemWH = (SCREEN_WIDTH-30)/3 - 5;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    //
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 270, SCREEN_WIDTH-30, _margin*(SCREEN_WIDTH-30)/3) collectionViewLayout:_layout];
    CGFloat rgb = 252 / 255.0;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_infousv addSubview:_collectionView];
    [_collectionView registerClass:[CswPhotoCell class] forCellWithReuseIdentifier:@"CswPhotoCell"];
    //
    _infousv.contentSize=CGSizeMake(SCREEN_WIDTH,280+_margin*(SCREEN_WIDTH-30)/3);
    [self.collectionView setCollectionViewLayout:_layout];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CswPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CswPhotoCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        [self pushTZImagePickerController];
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
//        [sheet showInView:self.view];
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] tz_containsString:@"GIF"]) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 9;
            imagePickerVc.allowPickingGif = TRUE;
            imagePickerVc.allowPickingOriginalPhoto = TRUE;
            imagePickerVc.allowPickingMultipleVideo = TRUE;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    
        // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = TRUE; // 在内部显示拍照按钮
    // imagePickerVc.photoWidth = 1000;
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = TRUE;
    imagePickerVc.allowPickingImage = TRUE;
    imagePickerVc.allowPickingOriginalPhoto = TRUE;
    imagePickerVc.allowPickingGif = TRUE;
    imagePickerVc.allowPickingMultipleVideo = TRUE; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = TRUE;
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = FALSE;
    imagePickerVc.needCircleCrop = FALSE;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    
    imagePickerVc.isStatusBarDefault = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = TRUE;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
            //NSLog(@"路径:%@",phAsset.accessibilityPath);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
//     [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
//     NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
//     //Export completed, send video here, send by outputPath or NSData
//     //导出完成，在这里写上传代码，通过路径或者通过NSData上传
//    
//     }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
            //NSLog(@"%@",[phAsset valueForKey:@"directory"]);
            if([pic isEqualToString:@""])
                pic = [NSString stringWithFormat:@"%@/%@",[phAsset valueForKey:@"directory"],fileName];
            else
                pic = [NSString stringWithFormat:@"%@,%@/%@",pic,[phAsset valueForKey:@"directory"],fileName];
            //NSLog(@"%@",phAsset);
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}
#pragma clang diagnostic pop
//
-(void)textFieldDidChange :(UITextField *)theTextField{
    //NSLog( @"text changed: %@", theTextField.text);
    if(pd.length > theTextField.text.length)
    {
        if(sj.length == 0)
            goto TG;
        sj = [sj substringToIndex:sj.length - 1];
    }
    else{
        NSUInteger le = theTextField.text.length - 1;
        NSString *useri = theTextField.text;
        NSString *usero = [useri substringWithRange:NSMakeRange(le,1)];
        usero = [useri substringWithRange:NSMakeRange(le,1)];
        sj = [sj stringByAppendingFormat:@"%@",usero];
    }
    if(theTextField.text.length > 9 && theTextField.text.length <= 12)
        _cmoney.font = [UIFont systemFontOfSize:23];
    else if(theTextField.text.length > 12)
        _cmoney.font = [UIFont systemFontOfSize:18];
    else
        _cmoney.font = [UIFont systemFontOfSize:30];
    pd=theTextField.text;
TG:
    _cmoney.text=[NSString stringWithFormat:@"¥ %.2f",sj.floatValue];
    pd = [NSString stringWithFormat:@"¥ %.2f",sj.floatValue];
    _cmoneyns = [NSString stringWithFormat:@"%.2f",sj.floatValue];
    //NSLog(@"sj 是：%@",sj);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"dsdsd");
    if(_keyboardIsVisible)
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)keyboardDidShow{
    _keyboardIsVisible = YES;
}

- (void)keyboardDidHide{
    _keyboardIsVisible = NO;
}

- (IBAction)isdone:(id)sender {
    pic = @"";
    [self printAssetsName:_selectedAssets];
    [self saveImageToCustomAblum];
    //
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserType.plist"];
    NSMutableArray *usersDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    if ([self checkInput]==NO) {
        return;
    }
    //
    if (!_isget)
    {
        self.cmoneyns = [NSString stringWithFormat:@"-%@",self.cmoneyns];
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
    s.name = self.ctitle.text;
    s.time = self.ctime.text;
    s.cswtype = self.ctype.text;
    s.money = [NSNumber numberWithFloat:[self.cmoneyns floatValue]];
    s.more = self.cmore.text;
    s.picarray = pic;
    //类型值修改
    if([self.ctype.text isEqualToString:@""])
        self.ctype.text = NSLocalizedString(@"noname", @"");
    if(_sourcedata == NULL)
        [self ChangeTypeMoney:self.ctype.text newType:self.ctype.text usersDic:usersDic plistPath:plistPath];
    else
        [self ChangeTypeMoney:_sourcedata[0] newType:self.ctype.text usersDic:usersDic plistPath:plistPath];
    NSError *error;
    if (![self.context save:&error]) {
        NSLog(@"出错：%@",error);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) checkInput{
    NSString *value_score = [self.cmoneyns stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
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

-(void)saveImageToCustomAblum{
    PHAssetCollection *assetCollection = [Whole getAlbumCollection];
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //--告诉系统，要操作哪个相册
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        //--添加图片到自定义相册--追加--就不能成为封面了
        [collectionChangeRequest addAssets:_selectedAssets];
        //--插入图片到自定义相册--插入--可以成为封面
        //[collectionChangeRequest insertAssets:_selectedAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    if (error) {
        //[SVProgressHUD showErrorWithStatus:@"保存失败"];
        NSLog(@"保存失败");
        return;
    }
    //[SVProgressHUD showSuccessWithStatus:@"保存成功"];
    NSLog(@"保存成功");
}
//
/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original iseq:(NSArray*)lgsj
{
    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = NO;//Yes同步 No不同步
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets)
    {
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //NSLog(@"%@", result);
            NSString *pict = [NSString stringWithFormat:@"%@/%@",[asset valueForKey:@"directory"],[asset valueForKey:@"filename"]];
            for(NSInteger i=0;i<lgsj.count;i++)
            {
                //NSLog(@"%@\n%@",pict,lgsj[i]);
                if([pict isEqualToString:lgsj[i]])
                {
                    [_selectedAssets addObject:asset];
                    [_selectedPhotos addObject:result];
                    //NSLog(@"%@",_selectedPhotos);
                }
            }
            [_collectionView reloadData];
        }];
    }
}

-(void)ChangeTypeMoney:(NSString *)oldType newType:(NSString *)newType usersDic:(NSMutableArray *)usersDic plistPath:(NSString *)plistPath
{
   NSString *theend,*theend2;
    if([oldType isEqualToString:newType])
    {
        NSMutableDictionary *new= [[NSMutableDictionary alloc]init];
        for(int i = 0;i<usersDic.count;i++)
        {
            NSMutableDictionary *dic = [usersDic objectAtIndex:i];
            NSString *nowtype = [dic valueForKey:@"name"];
            if([nowtype isEqual: self.ctype.text])
            {
                NSString *typem = [dic valueForKey:@"money"];
                //计算
               theend = [NSString stringWithFormat:@"%.2f",[self.cmoneyns floatValue] + [typem floatValue] - [_sourcedata[1] floatValue]];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:self.ctype.text forKey:@"name"];
                [dic setObject:theend forKey:@"money"];
                [usersDic setObject:dic atIndexedSubscript:i];
                [Whole settp:usersDic];
                [usersDic writeToFile:plistPath atomically:YES];
                goto NOITEM1;
            }
        }
        [new setObject:self.ctype.text forKey:@"name"];
        [new setObject:self.cmoneyns forKey:@"money"];
        [usersDic addObject:new];
        [Whole settp:usersDic];
        [usersDic writeToFile:plistPath atomically:YES];
    NOITEM1:
        return;
    }
    else
    {
        int j = -1,k = -1;
        NSString *tm,*tn;
        NSMutableDictionary *new2= [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dicy = [NSMutableDictionary dictionary];
        NSMutableDictionary *dicx = [NSMutableDictionary dictionary];
        for(int i = 0;i<usersDic.count;i++)
        {
            NSMutableDictionary *dic = [usersDic objectAtIndex:i];
            NSString *nowtype = [dic valueForKey:@"name"];
            if([nowtype isEqualToString: self.ctype.text])
            {
                tm = [dic valueForKey:@"money"];
                dicx = dic;
                k = i;
                if(j != -1)
                    goto NOITEM2;
            }
            else if([nowtype isEqualToString: _sourcedata[0]])
            {
                tn = [dic valueForKey:@"money"];
                dicy = dic;
                j = i;
                if(k != -1)
                    goto NOITEM2;
            }
        }
        //说明k == 0;
        theend2 = [NSString stringWithFormat:@"%.2f",[tn floatValue] - [_sourcedata[1] floatValue]];
        [dicy setObject:_sourcedata[0] forKey:@"name"];
        [dicy setObject:theend2 forKey:@"money"];
        [usersDic setObject:dicy atIndexedSubscript:j];
        [new2 setObject:self.ctype.text forKey:@"name"];
        [new2 setObject:self.cmoneyns forKey:@"money"];
        [usersDic addObject:new2];
        [Whole settp:usersDic];
        [usersDic writeToFile:plistPath atomically:YES];
        return;
    NOITEM2:
        theend = [NSString stringWithFormat:@"%.2f",[self.cmoneyns floatValue] + [tm floatValue]];//new
        theend2 = [NSString stringWithFormat:@"%.2f",[tn floatValue] -[_sourcedata[1] floatValue]];
        [dicx setObject:self.ctype.text forKey:@"name"];//new
        [dicy setObject:_sourcedata[0] forKey:@"name"];
        [dicx setObject:theend forKey:@"money"];//new
        [dicy setObject:theend2 forKey:@"money"];
        [usersDic setObject:dicx atIndexedSubscript:k];//new
        [usersDic setObject:dicy atIndexedSubscript:j];
        [Whole settp:usersDic];
        [usersDic writeToFile:plistPath atomically:YES];
    }
}
@end
