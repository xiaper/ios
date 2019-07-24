//
//  KFDSChatViewController.h
//  bdui
//
//  Created by 萝卜丝 on 2018/11/29.
//  Copyright © 2018年 Bytedesk.com. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <bytedesk-core/bdcore.h>

// 客服对话窗口

@interface BDChatKFViewController : QMUICommonTableViewController

#pragma mark - 访客端接口

/**
 工作组会话

 @param wId <#wId description#>
 @param title <#title description#>
 @param isPush <#isPush description#>
 */
- (void) initWithWorkGroupWid:(NSString *)wId withTitle:(NSString *)title withPush:(BOOL)isPush;

- (void) initWithWorkGroupWid:(NSString *)wId withTitle:(NSString *)title withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

/**
 指定坐席会话

 @param uId <#uId description#>
 @param title <#title description#>
 @param isPush <#isPush description#>
 */
- (void) initWithAgentUid:(NSString *)uId withTitle:(NSString *)title withPush:(BOOL)isPush;

- (void) initWithAgentUid:(NSString *)uId withTitle:(NSString *)title withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

#pragma mark - 客服端接口

/**
 从会话列表进入：访客会话、联系人会话、群组会话

 @param threadModel <#threadModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush;

- (void) initWithThreadModel:(BDThreadModel *)threadModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

/**
 联系人会话

 @param contactModel <#contactModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush;

- (void) initWithContactModel:(BDContactModel *)contactModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

/**
 群组会话

 @param groupModel <#groupModel description#>
 @param isPush <#isPush description#>
 */
- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush;

- (void) initWithGroupModel:(BDGroupModel *)groupModel withPush:(BOOL)isPush withCustom:(NSDictionary *)custom;

#pragma mark - 公共接口



@end





