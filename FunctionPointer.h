//
//  FunctionPointer.h
//  AudioServicesTest
//
//  Created by Julius Parishy on 11/9/14.
//  Copyright (c) 2014 Julius Parishy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef void(^AudioServicesCompletionBlock)(SystemSoundID soundID, void *userData);

@interface AudioServicesCompletionFunctionPointer : NSObject

/*
 * Pass the same SystemSoundID & userData you pass to `AudioServicesAddSystemSoundCompletion`.
 * `block` is the block you'd like to be called for the completion handler.
 *
 * A weak reference is held to the instance returned so you must keep it alive by
 * holding a strong reference or it will be deallocated prematurely.
 */
- (instancetype)initWithSystemSoundID:(SystemSoundID)systemSoundID block:(AudioServicesCompletionBlock)block userData:(void *)userData;

/*
 * Pass this as the completion handler to `AudioServicesAddSystemSoundCompletion`
 */
+ (AudioServicesSystemSoundCompletionProc)completionHandler;

@end
