//
//  KFSupportArticleViewController.h
//  demo
//
//  Created by 宁金鹏 on 2019/5/30.
//  Copyright © 2019 KeFuDaShi. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class BDArticleModel;

@interface KFSupportArticleViewController : QDCommonTableViewController

- (void)initWithArticleModel:(BDArticleModel *)articleModel;

@end

NS_ASSUME_NONNULL_END
