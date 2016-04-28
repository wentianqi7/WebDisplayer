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

const int HISTORY_SIZE = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVars];
    if (_projects) {
        // get all valid projects
        NSMutableArray *projResult = [_utils getJsonContent:WEB_DIR filename:@"/projects.json"];
        for (NSMutableDictionary *dic in projResult) {
            NSString *title = dic[@"title"];
            NSString *projID = dic[@"id"];
            NSString *url = dic[@"url"];
            if (title && projID && url) {
                [_idToTitleMap setValue:title forKey:projID];
                [_idToUrlMap setValue:url forKey:projID];
                NSLog(@"id = %@, name = %@", projID, title);
            }
        }
    }
}

- (void) initVars {
    _projects = [[NSMutableArray alloc] init];
    _idToTitleMap = [[NSMutableDictionary alloc] init];
    _idToUrlMap = [[NSMutableDictionary alloc] init];
    _utils = [[Utils alloc] init];
    _projects = [[DBManager getSharedInstance] getRecentHistory:HISTORY_SIZE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _projects.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    if (indexPath.row == _projects.count) {
        cell.tableCellText.text = @"All Projects";
        cell.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    } else {
        NSString *projID = [_projects objectAtIndex:indexPath.row];
        cell.tableCellText.text = _idToTitleMap[projID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    if (indexPath.row == _projects.count) {
        viewController.destStr = NULL;
        viewController.isFirstTime = @"No";
    } else {
        NSString *projID = [_projects objectAtIndex:indexPath.row];
        viewController.destStr = _idToUrlMap[projID];
    }
    [self presentViewController:viewController animated:NO completion:nil];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return tableView.bounds.size.height / 10.f;
}


@end
