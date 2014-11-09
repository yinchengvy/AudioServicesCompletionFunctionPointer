//
//  FunctionPointer.m
//  AudioServicesTest
//
//  Created by Julius Parishy on 11/9/14.
//  Copyright (c) 2014 Julius Parishy. All rights reserved.
//

#import "FunctionPointer.h"

void AudioServicesSystemSoundDidComplete(SystemSoundID soundID, void *userData);

@interface AudioServicesCompletionFunctionPointer ()

@property (nonatomic, assign) SystemSoundID systemSoundID;
@property (nonatomic, unsafe_unretained) void *userData;
@property (nonatomic, copy) AudioServicesCompletionBlock completionBlock;

@end

@implementation AudioServicesCompletionFunctionPointer

+ (NSMapTable *)sharedMapTable
{
    static NSMapTable *mapTable = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    });
    
    return mapTable;
}

- (instancetype)initWithSystemSoundID:(SystemSoundID)systemSoundID block:(AudioServicesCompletionBlock)block userData:(void *)userData
{
    if((self = [super init]))
    {
        self.systemSoundID = systemSoundID;
        self.userData = userData;
        self.completionBlock = block;
        
        NSMapTable *mapTable = self.class.sharedMapTable;
        
        NSValue *key = [NSValue valueWithPointer:self.userData];
        [mapTable setObject:self forKey:key];
    }
    
    return self;
}

- (void)dealloc
{
    NSMapTable *mapTable = self.class.sharedMapTable;
    
    NSValue *key = [NSValue valueWithPointer:_userData];
    [mapTable removeObjectForKey:key];
}

+ (AudioServicesSystemSoundCompletionProc)completionHandler
{
    return &AudioServicesSystemSoundDidComplete;
}

@end

void AudioServicesSystemSoundDidComplete(SystemSoundID soundID, void *userData)
{
    NSMapTable *mapTable = [AudioServicesCompletionFunctionPointer sharedMapTable];
    
    NSValue *key = [NSValue valueWithPointer:userData];
    AudioServicesCompletionFunctionPointer *functionPointer = (AudioServicesCompletionFunctionPointer *)[mapTable objectForKey:key];
    
    NSCAssert(functionPointer != nil, @"No block for this userData found.");
    
    if(functionPointer.systemSoundID != soundID)
        return;
    
    AudioServicesCompletionBlock block = functionPointer.completionBlock;
    block(soundID, userData);
}
