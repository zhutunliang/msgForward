//
//  Person.m
//  MessageForward
//
//  Created by hong on 17/5/23.
//  Copyright © 2017年 hong. All rights reserved.
//

#import "Person.h"
#import "Man.h"
#import <objc/runtime.h>

@implementation Person

void run ()
{
    NSLog(@"runrunrun");
}

+(BOOL) resolveInstanceMethod:(SEL)sel
{
    NSLog(@"resolveInstanceMethod");
    if (sel == @selector(run)) {
        class_addMethod(self, sel, (IMP)run,  "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

-(id) forwardingTargetForSelector:(SEL)aSelector
{
    NSLog(@"forwardingTargetForSelector");
    return [super forwardingTargetForSelector:aSelector];
}

-(NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector
{
    NSLog(@"methodSignatureForSelector");
    if (aSelector == @selector(runrun)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
//    NSString *sel = NSStringFromSelector(aSelector);
//    if ([sel isEqualToString:@"runrun"]) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
    return [super methodSignatureForSelector:aSelector];
}

-(void) forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"forwardInvocation");
    SEL selector = [anInvocation selector];
    Man *man  = [Man new];
    if ([man respondsToSelector:selector]) {
      return  [anInvocation invokeWithTarget:man];
    }
    
    return [super forwardInvocation:anInvocation];
}




@end
