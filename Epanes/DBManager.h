//
//  DBManager.h
//  Epanes
//
//  Created by Tianqi Wen on 3/17/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject {
    NSString* databasePath;
}

+(DBManager*) getSharedInstance;
-(BOOL) createDB;
-(BOOL) saveHistoryData:(int) projID;
-(NSMutableArray*) getRecentHistory:(int)count;
-(BOOL) savePrevProjUrl:(NSString *) prevUrl;
-(NSString *) getPrevProject;

@end
