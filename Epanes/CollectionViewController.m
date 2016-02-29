//
//  CollectionViewController.m
//  Epanes
//
//  Created by Rainy Yang on 2/17/16.
//  Copyright (c) 2016 Tianqi Wen. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "ViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *webDir = @"http://epanes.math.cmu.edu/json/";
	NSString *filename = @"default.json";
	
	_projNames = [[NSMutableArray alloc] init];
	_projUrls = [[NSMutableArray alloc] init];
	
	NSMutableArray *result = [self getJsonContent:webDir filename:filename];
	
	for (NSMutableDictionary *dic in result) {
		NSString *string = dic[@"project"];
		if (string) {
			// valid project field found
			NSString *destStr = [self processString:string];
			
			NSLog(@"proejct json name = %@", destStr);

			NSMutableArray *res  = [self getJsonContent:webDir filename:destStr];
			
			for (NSMutableDictionary *projDic in res) {
				NSString *name = projDic[@"name"];
				NSString *url = projDic[@"url"];
				if (name && url) {
					// add name to array
					NSString *nameStr = [self processString:name];
					[_projNames addObject:nameStr];
					NSLog(@"name = %@, size of array = %li", nameStr, _projNames.count);
					
					// add url to array
					NSString *urlStr = [self processString:url];
					[_projUrls addObject:urlStr];
					NSLog(@"url = %@", urlStr);
					break;
				} else {
					NSLog(@"Error in target url response: %@, %@", name, url);
				}
			}
			
		} else {
			NSLog(@"Error in default.json response: %@", string);
		}
	}
	
	
}

// get json content from given website with filename
- (NSMutableArray *)getJsonContent:(NSString *)webDir filename:(NSString *)filename {
	NSHTTPURLResponse *response = nil;
	NSString *sourceStr = [NSString stringWithFormat:[webDir stringByAppendingString:filename]];
	NSURL *sourceUrl = [NSURL URLWithString:[sourceStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:sourceUrl
												  cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSMutableArray *result  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
	return result;
}

// encode the input string
- (NSString *)processString:(NSString *)inputStr {
	NSData *data = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
	NSString *outputStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return outputStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	//NSLog(@"number of items in section = %li, %li", _projNames.count, _projUrls.count);
    return _projNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
	cell.textLabel.text = [_projNames objectAtIndex:indexPath.row];
    //cell.textLabel.text = [NSString stringWithFormat:@"%li", indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
	viewController.destStr = [_projUrls objectAtIndex:indexPath.row];
	[self presentModalViewController:viewController animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end
