//
//  MBSimpleStorage.h
//  MVPExample
//
//  Created by Kovalev_A on 12.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface DataBaseAccessObject : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
+ (instancetype)storageWithEntityName:(NSString *)entityName managedModelName:(NSString *)managedModel transformBlock:(void(^)(id obj, __kindof NSManagedObject *cachedObj))transform sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptors;
- (instancetype)initWithEntityName:(NSString *)entityName managedModelName:(NSString *)managedModel transformBlock:(void(^)(id obj, __kindof NSManagedObject *cachedObj))transform sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptors;
- (NSFetchRequest *)fetchRequest;
- (void)insertObjects:(NSArray *)objects;
- (void)removeObject:(__kindof NSManagedObject *)object;
- (void)changeObject:(__kindof NSManagedObject *)object;

@end
