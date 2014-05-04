//
//  Sneaky.m
//  Feinsches
//
//  Created by Mafia on 4/29/14.
//  Copyright (c) 2014 Stephen Sachson. All rights reserved.
//

#import "Sneaky.h"
#include <dlfcn.h>

#define kPATH "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/usr/lib/CarrierBundleUtilities.dylib"

@implementation Sneaky

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        void *this=dlopen(kPATH, RTLD_NOW);
        if (this) {
            printf("this is here");
            void (* somefunction)() = dlsym(this, "");
            
            somefunction();
        }
        
        dlclose(this);
        
    }
    return self;
}

@end
