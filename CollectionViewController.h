//
//  CollectionViewController.h
//  Epanes
//
//  Created by Tianqi Wen on 2/15/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *projectObjects;

@end
