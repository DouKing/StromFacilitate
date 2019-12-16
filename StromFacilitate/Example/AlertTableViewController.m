//
//  AlertTableViewController.m
//  StromFacilitate
//
//  Created by DouKing on 2019/2/12.
//  Copyright © 2019 douking. All rights reserved.
//

#import "AlertTableViewController.h"
#import "UIAlertController+STM.h"

typedef NS_ENUM(NSInteger, AlertType){
  AlertTypeTitle,

  AlertTypeCount
};
static NSString * const AlertTypeNameMapping[] = {
  [AlertTypeTitle] = @"Type1",
};

@interface AlertTableViewController ()

@property (nonatomic, assign) UIAlertControllerStyle alertStyle;

@end

@implementation AlertTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"ActionSheet", @"Alert"]];
  [segment addTarget:self action:@selector(_handleSegmentAction:) forControlEvents:UIControlEventValueChanged];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
  segment.selectedSegmentIndex = UIAlertControllerStyleAlert;
  self.alertStyle = UIAlertControllerStyleAlert;
}

- (void)_handleSegmentAction:(UISegmentedControl *)sender {
  self.alertStyle = sender.selectedSegmentIndex;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AlertType row = indexPath.row;
  switch (row) {
    case AlertTypeTitle: {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"这是标题" message:@"这是描述信息，详细信息，说明!" preferredStyle:self.alertStyle];
      [alert stm_setTitleFont:[UIFont systemFontOfSize:18] color:[UIColor redColor]];
      [alert stm_setMessageFont:[UIFont systemFontOfSize:15] color:[UIColor lightGrayColor]];

      UIViewController *vc = [UIViewController new];
      vc.preferredContentSize = CGSizeMake(0, 80);
      alert.stm_contentViewController = vc;

      UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
      cancel.stm_image = [UIImage imageNamed:@"img_goBack_icon"];
      cancel.stm_imageTintColor = [UIColor magentaColor];
      cancel.stm_titleTextColor = [UIColor orangeColor];
      cancel.stm_titleTextAlignment = NSTextAlignmentRight;
      [alert addAction:cancel];

      [alert stm_addDefaultStyleActionsWithTitles:@[@"1", @"2"] handler:^(UIAlertAction * _Nonnull action, NSInteger index) {
        STMLog(@"index: %ld, title: %@", (long)index, action.title);
      }];

      [alert stm_addActionWithTitle:@"A" style:UIAlertActionStyleDestructive handler:nil];

      [self presentViewController:alert animated:YES completion:nil];
      // After view is loaded
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert stm_setVisualEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        alert.view.tintColor = [UIColor greenColor];
      });
      vc.view.backgroundColor = [UIColor yellowColor];
    } break;

    case AlertTypeCount: {
    } break;
  }
}

@end
