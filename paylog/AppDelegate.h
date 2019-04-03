//
//  AppDelegate.h
//  paylog
//
//  Created by GitCsw on 2017/7/6.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
//@property (readonly, strong) NSPersistentContainer *persistentContainer;//原始函数
- (void)saveContext;
//
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
//
@end

