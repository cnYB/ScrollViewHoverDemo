//
//  ViewController.m
//  商品详情
//
//  Created by 杨育彬 on 16/1/16.
//  Copyright © 2016年 杨育彬. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+JZExtension.h"

@interface ViewController () <UIWebViewDelegate,UIScrollViewDelegate>
// 控件
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// WebView高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conWebViewHeigth;
// 选项卡Top约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTabTop;
// 选项卡应该停留的位置
@property (assign, nonatomic) CGFloat stopY;

@end

// 商品详情高度
static CGFloat const headH = 400;
// 选项卡高度
static CGFloat const tabH = 44;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor yellowColor]];
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://v3.bootcss.com/"]]];
    // 设置网页本身不可滚动
    self.webView.scrollView.scrollEnabled = NO;
    // 设置代理
    self.webView.delegate = self;
    self.scrollView.delegate = self;
    // 不需要添加额外的滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 使用UINavigationController+JZExtension.h的属性控制导航栏透明度
    self.navigationController.navigationBarBackgroundAlpha = 0;
    // 选项卡应该停留的位置
    self.stopY = (headH - tabH);
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 获取网页加载完的高度
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    // 设置到之前预设的webView高度约束上
    self.conWebViewHeigth.constant = webViewHeight;
    [self.view layoutIfNeeded];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    // 选项卡悬停的位置
    CGFloat stopOffsetY = offsetY - self.stopY + 20;
    
    if (stopOffsetY <= 0) { // 未到达悬停位置
        // 透明度
        CGFloat alpha = offsetY / self.stopY;
        self.navigationController.navigationBarBackgroundAlpha = alpha;
        self.conTabTop.constant = 0;
    } else { // 到达悬停位置
        self.navigationController.navigationBarBackgroundAlpha = 1;
        self.conTabTop.constant = stopOffsetY;
    }
    [self.view layoutIfNeeded];
}

@end
