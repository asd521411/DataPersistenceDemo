//
//  Penson+CoreDataProperties.m
//  
//
//  Created by 草帽~小子 on 2019/9/1.
//
//

#import "Penson+CoreDataProperties.h"

@implementation Penson (CoreDataProperties)

+ (NSFetchRequest<Penson *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Penson"];
}

@dynamic name;
@dynamic age;
@dynamic height;
@dynamic sex;

@end
