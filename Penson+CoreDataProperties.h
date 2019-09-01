//
//  Penson+CoreDataProperties.h
//  
//
//  Created by 草帽~小子 on 2019/9/1.
//
//

#import "Penson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Penson (CoreDataProperties)

+ (NSFetchRequest<Penson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nonatomic) double height;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
