//
//  KKImageToolInfo.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/3.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKImageToolInfo.h"
#import "KKClassList.h"

@interface KKImageToolInfo()

@property (nonatomic, strong) NSString *toolName; //readonly
@property (nonatomic, strong) NSArray *subtools;  //readonly
@end


@implementation KKImageToolInfo

+ (KKImageToolInfo *)toolInfoForToolClass:(Class<KKImageToolProtocol>)toolClass;
{
    if([(Class)toolClass conformsToProtocol:@protocol(KKImageToolProtocol)]){
        KKImageToolInfo *info = [KKImageToolInfo new];
        info.toolName  = NSStringFromClass(toolClass);
        info.title     = [toolClass defaultTitle];
        info.iconImage = [toolClass defaultIconImage];
        info.subtools = [toolClass subtools];
        info.orderNum = [toolClass orderNum];
        return info;
    }
    return nil;
}

+ (NSArray *)toolsWithToolClass:(Class<KKImageToolProtocol>)toolClass
{
    NSMutableArray *array = [NSMutableArray array];
    
    KKImageToolInfo *info = [KKImageToolInfo toolInfoForToolClass:toolClass];
    if(info){
        [array addObject:info];
    }
    
    NSArray *list = [KKClassList subclassesOfClass:toolClass];
    for(Class subtool in list){
        info = [KKImageToolInfo toolInfoForToolClass:subtool];
        if(info){
            [array addObject:info];
        }
    }
    return [array copy];
}

+ (NSArray *)sortWithTools:(NSArray *)subTools{

    subTools = [subTools sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat dockedNum1 = [obj1 orderNum];
        CGFloat dockedNum2 = [obj2 orderNum];
        
        if(dockedNum1 < dockedNum2){
            return NSOrderedAscending;
        }
        else if(dockedNum1 > dockedNum2){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    return subTools;
}


@end
