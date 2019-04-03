//
//  ConstCoreDataProperties.h
//  paylog
//
//  Created by GitCsw on 2017/7/17.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "Consts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Consts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *time;
@property (nullable, nonatomic, retain) NSString *cswtype;
@property (nullable, nonatomic, retain) NSNumber *money;
@property (nullable, nonatomic, retain) NSString *more;
@property (nullable, nonatomic, retain) NSString *picarray;

@end

NS_ASSUME_NONNULL_END
