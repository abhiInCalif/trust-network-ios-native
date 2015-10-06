//
//  ReadWritePlist.h
//  TrustNetwork
//
//  Created by Abhinav Khanna on 10/5/15.
//  Copyright © 2015 Abhinav Khanna. All rights reserved.
//

#ifndef ReadWritePlist_h
#define ReadWritePlist_h

@interface ReadWritePlist : NSObject

-(NSDictionary*) readFromPlist:(NSString*)plistName;
-(void) writeToPlist:(NSString*)phoneNumber;

@end

#endif /* ReadWritePlist_h */
