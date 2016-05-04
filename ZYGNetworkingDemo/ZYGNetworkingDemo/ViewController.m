//
//  ViewController.m
//  ZYGNetworkingDemo
//
//  Created by ZhangYunguang on 16/5/4.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ViewController.h"
#import "ZYGNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ZYGNetworking updateBaseUrl:@"http://apistore.baidu.com"];
    [ZYGNetworking getDataWithUrl:@"/microservice/cityinfo?cityname=beijing" param:nil progress:^(int64_t downloadedData, int64_t totalData) {
        
    } success:^(id response) {
        
    } failed:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
