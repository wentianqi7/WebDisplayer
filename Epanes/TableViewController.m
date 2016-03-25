//
//  TableViewController.m
//  Epanes
//
//  Created by Tianqi Wen on 2/29/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "ViewController.h"
#import "DBManager.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableButton addTarget:self action:@selector(tableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _projects = [[NSMutableArray alloc] init];
    _projNameMap = [[NSMutableDictionary alloc] init];
    _projUrlMap = [[NSMutableDictionary alloc] init];
    _projects = [[DBManager getSharedInstance] getRecentHistory:5];
    if (_projects) {
        // get all valid projects
        NSMutableArray *projResult = [self getJsonContent:@"http://epanes.math.cmu.edu" filename:@"/projects.json"];
        for (NSMutableDictionary *dic in projResult) {
            NSString *string = dic[@"title"];
            NSString *projID = dic[@"id"];
            NSString *url = dic[@"url"];
            if (string && projID && url) {
                [_projNameMap setValue:string forKey:projID];
                [_projUrlMap setValue:url forKey:projID];
                NSLog(@"id = %@, name = %@", projID, string);
            }
        }
    }
}

- (IBAction)tableButtonClick:(id)sender {
    NSLog(@"clicked");
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    viewController.destStr = NULL;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _projects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    NSString *projID = [_projects objectAtIndex:indexPath.row];
    cell.tableCellText.text = _projNameMap[projID];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    NSString *projID = [_projects objectAtIndex:indexPath.row];
    viewController.destStr = _projUrlMap[projID];
    NSLog(@"%@", viewController.destStr);
    [self presentViewController:viewController animated:YES completion:nil];
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

@end
