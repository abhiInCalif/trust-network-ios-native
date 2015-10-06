//
//  ReadWritePlist.m
//  TrustNetwork
//
//  Created by Abhinav Khanna on 10/5/15.
//  Copyright © 2015 Abhinav Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadWritePlist.h"

@implementation ReadWritePlist : NSObject 

-(NSDictionary*) readFromPlist:(NSString*)plistName {
    NSString *plistPath = [self getPathToPlist:plistName];
    NSDictionary* temp = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return temp;
}

-(NSString*) getPathToPlist:(NSString*)plistName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    
    return plistPath;
}

-(void) writeToPlist:(NSString*)phoneNumber {
    NSMutableDictionary* dictToWrite = [NSMutableDictionary dictionaryWithObject:phoneNumber forKey:@"phoneNumber"];
    [dictToWrite writeToFile:[self getPathToPlist:@"PhoneNumber"] atomically:YES];
}

@end