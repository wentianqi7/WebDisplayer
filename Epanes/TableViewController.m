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

const int HISTORY_SIZE = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableButton addTarget:self action:@selector(tableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initVars];
    if (_projects) {
        // get all valid projects
        NSMutableArray *projResult = [_utils getJsonContent:WEB_DIR filename:@"/projects.json"];
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

- (void) initVars {
    _projects = [[NSMutableArray alloc] init];
    _projNameMap = [[NSMutableDictionary alloc] init];
    _projUrlMap = [[NSMutableDictionary alloc] init];
    _utils = [[Utils alloc] init];
    _projects = [[DBManager getSharedInstance] getRecentHistory:HISTORY_SIZE];
}

- (IBAction)tableButtonClick:(id)sender {
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    viewController.destStr = NULL;
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [self presentViewController:viewController animated:NO completion:nil];
}



@end
