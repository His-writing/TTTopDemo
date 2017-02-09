//
//  ViewController.m
//  TTTopDemo
//
//  Created by shuzhenguo on 2017/1/9.
//  Copyright © 2017年 shuzhenguo. All rights reserved.
//

#import "ViewController.h"
#import "TTTopChannelContianerView.h"
#import "ContentTableViewController.h"

@interface ViewController ()<TTTopChannelContianerViewDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) TTTopChannelContianerView *topContianerView;
@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, weak) UIScrollView *contentScrollView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setupTopContianerView];
    [self setupChildController];
    [self setupContentScrollView];

}



#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        
        
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        
        
//        if (i==0) {
//            viewController.view.backgroundColor=[UIColor redColor];
//        }else if (i==1){
//        
//            viewController.view.backgroundColor=[UIColor blueColor];
//
//        }else if (i==2){
//        
//            viewController.view.backgroundColor=[UIColor yellowColor];
//
//        }else if (i==3){
//            viewController.view.backgroundColor=[UIColor blackColor];
//
//        
//        }
        
//        viewController.view.backgroundColor=[UIColor redColor];
//        viewController.title = self.arrayLists[i][@"title"];
//        viewController.urlString = self.arrayLists[i][@"urlString"];
        [self addChildViewController:viewController];
    }
}



#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    
    contentScrollView.showsVerticalScrollIndicator = FALSE;
    contentScrollView.showsHorizontalScrollIndicator = FALSE;

    contentScrollView.delegate = self;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
        for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
            NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
            if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                UITableView *theTableView = self.contentScrollView.subviews[i];
                NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                NSInteger gap = theIndex - currentIndex;
                if (gap<=2&&gap>=-2) {
                    continue;
                } else {
                    [theTableView removeFromSuperview];
                }
            }
            
        }
        
    }
}




#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}





#pragma mark --private Method--存储更新后的currentChannelsArray到偏好设置中
-(void)updateCurrentChannelsArrayToDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark --private Method--懒加载currentChannelsArray
-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        _currentChannelsArray = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"currentChannelsArray"];
        [_currentChannelsArray addObjectsFromArray:array];
        if (_currentChannelsArray.count == 0) {
            [_currentChannelsArray addObjectsFromArray:@[@"新闻", @"娱乐", @"视频", @"热点"]];
            [self updateCurrentChannelsArrayToDefaults];
        }
    }
    return _currentChannelsArray;
}


#pragma mark --private Method--初始化上方的新闻频道选择的View
- (void)setupTopContianerView{
    
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    TTTopChannelContianerView *topContianerView = [[TTTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top+20, [UIScreen mainScreen].bounds.size.width, 30)];
    
    topContianerView.channelNameArray = self.currentChannelsArray;
    topContianerView.delegate = self;
    self.topContianerView  = topContianerView;
    self.topContianerView.scrollView.delegate = self;
    [self.view addSubview:topContianerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --TTTopChannelContianerViewDelegate--点击加号按钮，展示或隐藏编辑新闻频道CollectionView
- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button {
    if (button.selected == NO) {//点击状态正常的加号buuton，显示编辑频道CollectionView
//        [self shouldShowChannelsEditCollectionView:YES];
    } else {//点击状态为已经被选中的加号buuton，显示编辑频道CollectionView
//        [self shouldShowChannelsEditCollectionView:NO];
    }
}

#pragma mark --TTTopChannelContianerViewDelegate--选择了某个新闻频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}


@end
