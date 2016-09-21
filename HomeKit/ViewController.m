//
//  ViewController.m
//  HomeKit
//
//  Created by 张君泽 on 16/9/19.
//  Copyright © 2016年 CloudEducation. All rights reserved.
//

#import "ViewController.h"
#import "textView.h"
#import <HomeKit/HomeKit.h>
@interface ViewController ()<HMHomeManagerDelegate,HMAccessoryDelegate,HMAccessoryBrowserDelegate>
@property (nonatomic, assign)CGFloat theHeight;
@property (nonatomic, strong)textView *textV;
///homeManager
@property (nonatomic, strong)HMHomeManager *homeManager;
@property (nonatomic, strong)HMAccessoryBrowser *browser;
@property (nonatomic, strong)HMHome *home;
@end

@implementation ViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.browser stopSearchingForNewAccessories];//停止查找新的附件
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeManager = [[HMHomeManager alloc] init];
    self.homeManager.delegate = self;
    [self makeHomes];
       // Do any additional setup after loading the view, typically from a nib.
}
- (void)makeHomes{
    //1 获取Primary Home和Homes集合
    HMHome *home = self.homeManager.primaryHome;
   
    NSLog(@"%@",home);
    for (HMHome *home in self.homeManager.homes) {//获取别墅
        NSLog(@"%@",home);
        [home addRoomWithName:@"" completionHandler:nil];//home中添加room
        
        for (HMAccessory *accessory in home.accessories) {
            NSLog(@"%@",accessory);
        }
        for (HMRoom *room in home.rooms) {//获取房间
            for (HMAccessory *accessory in room.accessories) {//获取只能设备
                accessory.delegate = self;
//                Accessories封装了物理配件的状态,因此它不能被用户创建。想要允许用户给家添加新的配件,我们可以使HMAccessoryBrowser对象找到一个与home没有关联的配
                self.browser = [[HMAccessoryBrowser alloc] init];
                
                _browser.delegate = self;
                [_browser startSearchingForNewAccessories];//开始查找新设备
                
            }
        }
    };
//2.创建Homes和添加Accessories
//    Observing HomeKit Database Changes  数据改变  HomeKit Constants Reference
//    想了用户可以使用哪些语言与Siri进行交互,请参阅HomeKit User Interface Guidelines文档中的"Siri Integration"创建Homes
    [self.homeManager addHomeWithName:@"myHome" completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
        if (error) {//添加失败
            
        }else{//添加成功
            
        }
    }];
}
//3.HMZone  分区
- (void)makeHMZone{
    NSString *zoneName = @"loft";
    [self.homeManager.primaryHome addZoneWithName:zoneName completionHandler:^(HMZone * _Nullable zone, NSError * _Nullable error) {
        [zone addRoom:nil completionHandler:nil];//分区添加Room
    }];
}
//4.观察HomeKit数据库的变化
#pragma mark HMHomeManagerDelegate
- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager{
    //如果多个视图控制器展示了homes相关信息,你可以发布一个更改通知去更新所有视图。
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upView" object:self];
}
//5.服务(HMService)代表了一个配件(accessory)的某个功能和一些具有可读写的特性(HMCharacteristic)。一个配件可以拥有多项服务,一个服务也可以有很多特性
- (void)serviceWithAccssory:(HMAccessory *)accessory{
    NSArray *services = accessory.services;
    for (HMService *serv in services) {
        HMAccessory *accessory = serv.accessory;
        NSString *name = serv.name;
        NSArray *characteristics = serv.characteristics;//特征
//        特性代表了一个服务的一个参数,它要么是只读、可读写或者只写
        NSString *serviceType = serv.serviceType;
        //服务更改名字  updateName  读取数值  readValueWithCompletionHandler
        for (HMCharacteristic *characteristic in characteristics) {
            [characteristic readValueWithCompletionHandler:^(NSError * _Nullable error) {
               //读取数值完成
                id value = characteristic.value;
            }];
            [characteristic writeValue:@100 completionHandler:nil];
        }
    }
    NSArray *lightServices = [self.homeManager.primaryHome servicesWithTypes:@[HMServiceTypeLightbulb]];
    NSArray *thermostatSerivices = [self.homeManager.primaryHome servicesWithTypes:@[HMServiceTypeThermostat]];//恒温器
}
//另外,在别的app更新了特性的值时也需要更新视图,在Observing Changes to Accessories中有描述。
//6.创建服务组一个服务组(HMServiceGroup)提
- (void)serviceGroup{
    NSString *str = @"Away Lights";
    [self.home addServiceGroupWithName:str completionHandler:^(HMServiceGroup * _Nullable group, NSError * _Nullable error) {
        [group addService:nil completionHandler:^(NSError * _Nullable error) {
            
        }];//服务组添加服务
    }];
    NSArray *serGroup = self.home.serviceGroups;
}
//7.测试HomeKitApp
#pragma mark HMAccessoryDelegate

#pragma mark HMAccessoryBrowserDelegate
//只有在startSearchingForNewAccessories方法调用之后或者stopSearchingForNewAccessories方法调用之前
- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory{//发现新设备
    [self.homeManager.primaryHome addAccessory:accessory completionHandler:^(NSError * _Nullable error) {//添加服务 home名字必须唯一
        
    }];
    [self.homeManager.primaryHome assignAccessory:accessory toRoom:nil completionHandler:nil];//分配到房间中
//    [self.accessoryPicker reloadAllComponents];
//    配件可提供一项或者多项服务,这些服务的特性是由制造商定义。想了解配件的服务和特性目的,请参阅Accessing Services and Characteristics.更改配件名称
    [accessory updateName:@"张三" completionHandler:^(NSError * _Nullable error) {
       //更改配件的名称
//        为Homes和Room添加Bridge(桥接口)
        
    }];
}
/*桥接口是配件中的一个特殊对象,它允许你和其他配件交流,但是不允许你直接和HomeKit交流。例如一个桥接口可以是控制多个灯的枢纽,它使用的是自己的通信协

议,而不是HomeKit配件通信协议。想要给home添加多个桥接口 ,你可以按照Adding Accessories to Homes and Rooms中所描述的步骤,添加任何类型的配件到home中。当你给home添加一个桥接口时,在桥接口底层的配件也会被添加到home中。正如Observing HomeKit Database Changes中所描述的那样,每次更改通知

设计模,home的代理不会接收到桥接口的home:didAddAccessory:代理消息,而是接收一个有关于配件的home:didAddAccessory:代理消息。在home中,要把桥接

口后的配件和任何类型的配件看成一样的--例如,把它们加入配件列表的配置表中。相反的是,当你给room增添一个桥接口时,这个桥接口底层的配件并不会自动地

添加到room中,原因是桥接口和它的的配件可以位于到不同的room中。*/

//Accessing Services and Characteristics”。
//动态更改XIB尺寸
- (void)makeXIBframe{
    _theHeight = 40;
    _textV = [textView shareTextView];
    _textV.lab1Str = @"我们的歌  唱起来  哈哈哈哈哈   哈哈哈 以前的果实的就是风口浪尖";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 300, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(clickTheBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //    _textV.labelHeight.constant = 20;
    [self.view addSubview:_textV];
}
- (void)clickTheBtn{
    _theHeight += 10;
    _textV.lab1Height.constant += 5;
    _textV.lab1Width.constant += 10;
    _textV.lab12.constant += 2;
//    NSLog(@"%.0f,% .0f,%.0f",_textV.lab12.constant,_textV.lab1Height.constant,_textV.lab1Width.constant);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
