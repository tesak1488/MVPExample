//
//  MBSimpleStorage.m
//  MVPExample
//
//  Created by Kovalev_A on 12.10.17.
//  Copyright © 2017 Kovalev_A. All rights reserved.
//

#import "DataBaseAccessObject.h"

@interface DataBaseAccessObject ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;
@property (nonatomic, copy) void(^transform)(id networkObj, __kindof NSManagedObject *cachedObj);
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSArray<NSSortDescriptor *> *sortDescriptors;

@end

@implementation DataBaseAccessObject

+ (instancetype)storageWithEntityName:(NSString *)entityName managedModelName:(NSString *)managedModel transformBlock:(void (^)(id, __kindof NSManagedObject *))transform sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptors
{
    return [[self alloc] initWithEntityName:entityName managedModelName:managedModel transformBlock:transform sortDescriptions:sortDescriptors];
}

- (instancetype)initWithEntityName:(NSString *)entityName managedModelName:(NSString *)managedModel transformBlock:(void (^)(id, __kindof NSManagedObject *))transform sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptors
{
    NSParameterAssert(entityName && managedModel && transform && sortDescriptors);
    self = [super init];
    if (self) {
        self.transform = transform;
        self.entityName = entityName;
        self.sortDescriptors = sortDescriptors;
        self.context = [self createContextFromModelName:managedModel];
    }
    return self;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:self.context];
    request.sortDescriptors = self.sortDescriptors;
    return request;
}

- (void)insertObjects:(NSArray *)objects
{
    for (id obj in objects) {
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.context];
        self.transform(obj, managedObject);
    }
    [self.context performBlock:^{
        NSError *error;
        NSAssert([self.context save:&error], error.localizedDescription);
    }];
}

- (void)removeObject:(id)object
{
    [self.context performBlock:^{
        NSError *error;
        [self.context deleteObject:object];
        NSAssert([self.context save:&error], error.localizedDescription);
    }];
}

- (void)changeObject:(id)object
{
    [self.context performBlock:^{
        NSError *error;
        [self.context refreshObject:object mergeChanges:YES];
        NSAssert([self.context save:&error], error.localizedDescription);
    }];
}

- (NSManagedObjectContext *)createContextFromModelName:(NSString *)modelName
{
    NSURL *modelPath = [NSBundle.mainBundle URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    NSPersistentStoreCoordinator *coordinator = [self coordinatorWithModel:model modelName:modelName];
    return contextWithCoordinator(coordinator);
}

- (NSPersistentStoreCoordinator *)coordinatorWithModel:(NSManagedObjectModel *)model modelName:(NSString *)modelName
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSURL *applicationDocumantsDirectory = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    NSURL *storeURL = [applicationDocumantsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", modelName]];
    NSError *error;
    NSPersistentStore *resultStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    NSAssert(resultStore, error.localizedDescription);
    return coordinator;
}

NSManagedObjectContext *contextWithCoordinator(NSPersistentStoreCoordinator *coordinator)
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    return context;
}

@end
