//
//  AppDelegate.m
//  paylog
//
//  Created by GitCsw on 2017/7/6.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 应用程序启动后自定义的重写点。
    // Override point for customization after application launch.
//    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSString *languageName = [appLanguages objectAtIndex:0];
//    NSLog(@"本地语言是：%@",languageName);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // 当应用程序即将从活动状态移动到非活动状态时执行(此函数的代码)。对于某些类型的临时中断（例如打进来的电话或SMS消息），或者当用户退出应用程序，此程序开始进入后台时执行(此函数的代码)。
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // 比如暂停正在进行的任务，关闭定时器，并使图形渲染回调。游戏应该在这里写相应方法(代码)来暂停游戏。
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 使用此方法释放共享资源、保存用户数据、取消计时器，并存储足够的应用程序状态信息，以恢复应用程序的当前状态，以防止其下次运行时候出现什么错误。
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // 如果您的应用程序支持后台执行(比如后台播放音乐，使用GPS等)，当用户退出此应用时，这种方法被称为替代applicationWillTerminate:。
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 作为从后台到活动状态的转换的一部分调用，在这里您可以撤消在进入后台时所做的许多更改。(比如退出时候你挂起的线程，计时器等，即时通信软件在这里最好重新和服务器建立连接)
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 在应用程序处于非活动状态时,重新启动暂停（或尚未启动）的任务。如果应用程序以前处于后台，可以选择刷新用户界面。
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // 应用程序即将终止时调用。如果适当的话就保存数据。见applicationDidEnterBackground:的描述。
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // 在应用程序终止之前保存应用程序管理对象上下文中的更改。
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

//@synthesize persistentContainer = _persistentContainer;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // 应用程序用于存储核心数据存储文件的目录。这个代码使用一个目录命名为“zoom.CoreDataTest”在应用程序的文件目录。
    // The directory the application uses to store the Core Data store file. This code uses a directory named "zoom.CoreDataTest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // 应用程序的托管对象模型。应用程序不能找到并加载它的模型是一个致命的错误。
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"paylog" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // 应用程序的持久化存储协调器。这个实现创建并返回一个协调器，为应用程序添加了存储。
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    // 创建协调器和存储区
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XMpaylog.sqlite"];//文件名(沙盘更目录)
    NSError *error = nil;
    NSString *failureReason = @"创建或加载应用程序的保存数据时出错。(There was an error creating or loading the application's saved data.)";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // 报告我们得到的任何错误。Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"初始化应用程序数据失败(Failed to initialize the application's saved data).";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"错误代码(YOUR_ERROR_DOMAIN):" code:9999 userInfo:dict];
        NSLog(@"未解决的错误(Unresolved error) %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // 返回应用程序的托管对象上下文(它已经绑定到应用程序的持久存储协调器).
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
        return _managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
        return nil;
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
/*- (NSPersistentContainer *)persistentContainer {
    // 应用程序的持久容器。这里的实现方法创建并返回一个容器，为应用程序加载了存储库。
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"paylog"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // 用代码替换此实现方法以正确处理错误。
                    // Replace this implementation with code to handle the error appropriately.
                    // abort()将使应用产生崩溃日志和终止。您不应该在运输应用程序？中使用此功能，尽管它在开发过程中可能有用。
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    ／*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     * 这里出现错误的典型原因包括：
                     * 父目录不存在，无法被创造，或不允许写入。
                     * 由于设备被锁定时，由于权限或数据保护，持久性存储不可访问。
                     * 设备已超出空间。
                     * 无法迁移到当前模型版本的存储区。
                       检查错误消息以确定实际问题是什么。
                    *／
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}//原始程序*/

#pragma mark - Core Data Saving support

/*- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // 用代码替换此处(实现方法)以正确处理错误。
        // Replace this implementation with code to handle the error appropriately.
        //abort()使应用程序生成崩溃日志并终止。您不应该在运输应用程序？中使用此功能，尽管它在开发过程中可能有用。
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}//原始程序*/
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
