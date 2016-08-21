//
//  ViewController.m
//  MKJTaoBaoPopAnimation
//
//  Created by 宓珂璟 on 16/8/21.
//  Copyright © 2016年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "ViewController.h"
#import "MKJAnimationViewController.h"

@interface ViewController ()
@property (nonatomic,strong) MKJAnimationViewController *mkjVC;
@property (nonatomic,strong) UIView *popView;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UINavigationController *nvc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置底部的背景颜色 （第一层）
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置AnimationVC的属性 （第二层）
    self.mkjVC = [[MKJAnimationViewController alloc] init];
    self.mkjVC.view.backgroundColor = [UIColor whiteColor];
    self.mkjVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.mkjVC.title = @"Animation";
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.mkjVC];

    [self addChildViewController:self.nvc];
    [self.view addSubview:self.nvc.view];
    // 设置开始按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"show" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickShow:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = self.nvc.view.center;
    [self.nvc.view addSubview:button];
    
    // 设置maskView (第三层)
    self.maskView = [[UIView alloc] initWithFrame:self.mkjVC.view.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskView.alpha = 0;
    [self.nvc.view addSubview:self.maskView];
    
    // 设置popVIew （第四层）
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
    self.popView.backgroundColor = [UIColor redColor];
    self.popView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.popView.layer.shadowOffset = CGSizeMake(3, 3);
    self.popView.layer.shadowOpacity = 0.8;
    self.popView.layer.shadowRadius = 5.0f;
    
    // closeButton
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button1.frame = CGRectMake(5, 5, 100, 30);
    [button1 addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.popView addSubview:button1];
    
    
}


// 点击动画开始
- (void)clickShow:(UIButton *)button
{
    // 开始的时候把popView加载到window上面去，类似于系统的actionSheet之类的弹窗
    [[UIApplication sharedApplication].windows[0] addSubview:self.popView];
    CGRect rec = self.popView.frame;
    rec.origin.y = self.view.bounds.size.height / 2;
    
    [UIView animateWithDuration:0.3 animations:^{
        // 先逆时针X轴旋转
        self.nvc.view.layer.transform = [self transform1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.nvc.view.layer.transform = [self transform2];
            self.maskView.alpha = 0.5;
            self.popView.frame = rec;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
}

// 动画关闭
- (void)close:(UIButton *)button
{
    CGRect rec = self.popView.frame;
    rec.origin.y = self.view.bounds.size.height;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.popView.frame = rec;
        self.maskView.alpha = 0;
        self.nvc.view.layer.transform = [self transform1];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.nvc.view.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished) {
            
            [self.popView removeFromSuperview];
            
        }];
        
    }];
    
}


- (CATransform3D)transform1{
    // 每次进来都进行初始化
    CATransform3D form1 = CATransform3DIdentity;
    form1.m34 = 1.0/-900;
    //缩小的效果
    form1 = CATransform3DScale(form1, 0.95, 0.95, 1);
    //x轴旋转
    form1 = CATransform3DRotate(form1, 15.0 * M_PI/180.0, 1, 0, 0);
    return form1;
    
}

- (CATransform3D)transform2{
    // 初始化
    CATransform3D form2 = CATransform3DIdentity;
    form2.m34 = [self transform1].m34;
    //向上平移
    form2 = CATransform3DTranslate(form2, 0, self.view.frame.size.height * (-0.08), 0);
    //再次缩小
    form2 = CATransform3DScale(form2, 0.8, 0.8, 1);
    return form2;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
