//
//  WXYListViewController.m
//  TXChat
//
//  Created by 陈爱彬 on 15/7/1.
//  Copyright (c) 2015年 lingiqngwan. All rights reserved.
//

#import "WXYListViewController.h"
#import "WXYArticleTableViewCell.h"
#import "WXYArticle.h"
#import <MJRefresh.h>
#import "TXWebViewController.h"

@interface WXYListViewController ()
<UITableViewDelegate,
UITableViewDataSource,
WXYArticleCellTapDelegate>
{
    BOOL _reloading;
    UITableView *_tableView;
    NSInteger _lastIndex;
    BOOL _isCanFetch;
    BOOL _isFirstRequest;
    
}
@property (nonatomic,strong) NSMutableArray *articleListArray;

@end

@implementation WXYListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleStr = @"微学园";
//    TXUser *user = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    if (_isGardenSubscription && user && user.gardenName && [user.gardenName length]) {
//        self.titleStr = [user.gardenName stringByAppendingString:@"公众号"];
//        self.umengEventText = @"园公众号";
//    }
    [self createCustomNavBar];
//    if (IOS7_OR_LATER) {
//        self.titleLb.frame = CGRectMake(60, 20, self.view.width_ - 120, kNavigationHeight);
//    }else{
//        self.titleLb.frame = CGRectMake(60, 0, self.view.width_ - 120, kNavigationHeight);
//    }
    
    [self setupWeiXueYuanTableView];
    if (_isGardenSubscription) {
//        [self fetchLocalPostGroupListWithMaxId:LLONG_MAX];
    }
    _isFirstRequest = YES;
//    [self fetchWeiXueYuanArticleListWithMaxId:LLONG_MAX];
}

#pragma mark - 按钮响应
- (void)onClickBtn:(UIButton *)sender
{
    if (sender.tag == TopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UI视图创建
- (void)setupWeiXueYuanTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.customNavigationView.maxY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - self.customNavigationView.maxY) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //添加下拉刷新功能
    __weak typeof(self)tmpObject = self;
//    _tableView.header = [MJTXRefreshGifHeader createGifRefreshHeader:^{
//        [tmpObject headerRereshing];
//    }];
    _tableView.header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [tmpObject headerRereshing];
    }];
    //    [self setTitle:MJRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
    MJRefreshAutoStateFooter *autoStateFooter = (MJRefreshAutoStateFooter *) _tableView.footer;
    [autoStateFooter setTitle:@"" forState:MJRefreshStateIdle];
    
}
#pragma mark - 上啦刷新下拉刷新
//下拉刷新
- (void)headerRereshing
{
    _isFirstRequest = NO;
    WXYSectionData *entity = [_articleListArray firstObject];
//    [self fetchWeiXueYuanArticleListWithMaxId:entity.groupId];
}

#pragma mark -
#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_articleListArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentify = @"";
    if (indexPath.row < [_articleListArray count]) {
        WXYSectionData *data = (WXYSectionData *)_articleListArray[indexPath.row];
        if (data.count == 1) {
            //新闻详情类型
            cellIndentify = @"newsCellIndentify";
        }else{
            //其他类型
            cellIndentify = @"normalCellIndentify";
        }
        WXYArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
        if (!cell) {
            cell = [[WXYArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        cell.articleData = data;
        return cell;
    }
    WXYArticleTableViewCell *zeroCell = [tableView dequeueReusableCellWithIdentifier:cellIndentify];
    if (!zeroCell) {
        zeroCell = [[WXYArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        zeroCell.backgroundColor = [UIColor clearColor];
        zeroCell.backgroundView = nil;
        zeroCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return zeroCell;
}
#pragma mark -
#pragma mark UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_articleListArray count]) {
        WXYSectionData *data = (WXYSectionData *)_articleListArray[indexPath.row];
        return data.rowHeight;
    }
    return 0;
}
#pragma mark - 下拉刷新

#pragma mark UIScrollView Methods
//滚动到最低
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [_tableView numberOfRowsInSection:0];
    if(rows > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
    }
}

#pragma mark - WXYArticleCellTapDelegate
- (void)tappedOnCellWithArticle:(WXYArticle *)article
{
    TXWebViewController *detailVc = [[TXWebViewController alloc] initWithURLString:article.articleUrlString];
    detailVc.requireShare = YES;
    if (_isGardenSubscription) {
//        TXUser *currentUser = [[TXChatClient sharedInstance] getCurrentUser:nil];
//        if (currentUser && currentUser.gardenName && [currentUser.gardenName length]) {
//            self.titleStr = [currentUser.gardenName stringByAppendingString:@"公众号"];
//        }else{
//            self.titleStr = @"公众号";
//        }
    }else{
        detailVc = [[TXWebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@&pf=WJY",article.articleUrlString]];
        detailVc.requireShare = YES;
        detailVc.titleStr = @"";
        [detailVc setShareUrl:article.shareUrl];
    }
//    PublishmentDetailViewController *detailVc = [[PublishmentDetailViewController alloc] initWithLinkURLString:article.articleUrlString];
//    if (_isGardenSubscription) {
//        detailVc.postType = TXHomePostType_GardenPost;
//    }else{
//        detailVc.postType = TXHomePostType_Learngarden;
//    }
    [self.navigationController pushViewController:detailVc animated:YES];
}
#pragma mark - post组装成group
//- (NSArray *)packageToGroupListWithPosts:(NSArray *)posts
//{
//    NSMutableArray *lists = [NSMutableArray array];
//    for (NSInteger i = 0; i < [posts count]; i++) {
//        TXPost *post = posts[i];
//        int64_t groupId = post.groupId;
//        NSString *groupIdString = [NSString stringWithFormat:@"%@",@(groupId)];
//        //判断是否包含
//        BOOL isContain = NO;
//        for (NSMutableDictionary *dict in lists) {
//            if ([[dict allKeys] containsObject:groupIdString]) {
//                //已包含该groupid
//                isContain = YES;
//                NSMutableArray *subGroup = dict[groupIdString];
//                [subGroup addObject:post];
//                [subGroup sortUsingComparator:^NSComparisonResult(TXPost *obj1, TXPost *obj2) {
//                    return obj1.orderValue > obj2.orderValue;
//                }];
//                [dict setObject:subGroup forKey:groupIdString];
//                break;
//            }
//        }
//        //组装进group
//        if (!isContain) {
//            //新创建个group
//            NSMutableArray *subGroup = [NSMutableArray array];
//            [subGroup addObject:post];
//            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
//            [subDict setObject:subGroup forKey:groupIdString];
//            //填加进返回的list中
//            [lists addObject:subDict];
//        }
//    }
//    return lists;
//}
#pragma mark - 网络请求
//- (void)fetchWeiXueYuanArticleListWithMaxId:(int64_t)maxId
//{
//    DDLogDebug(@"getPosts");
//    TXUser *user = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    if (!user) {
//        return;
//    }
//    if (_isGardenSubscription) {
//        [[TXChatClient sharedInstance].postManager fetchPostGroups:maxId gardenId:_isGardenSubscription ? user.gardenId : 0 onCompleted:^(NSError *error, NSArray *postGroups, BOOL hasMore) {
//            
//            if (error) {
//                [self showFailedHudWithError:error];
//                DDLogDebug(@"获取postType:%@ 请求error:%@",@(TXHomePostType_Learngarden),error);
//                [_tableView.header endRefreshing];
//                //刷新空白信息
//                BOOL isEmpty = [self.articleListArray count] > 0 ? NO : YES;
//                [self updateEmptyDataImageStatus:isEmpty];
//            }else{
//                //处理数据并刷新列表
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    NSMutableArray *subGroup = [NSMutableArray array];
//                    if (_isFirstRequest) {
//                        self.articleListArray = [NSMutableArray array];
//                    }
//                    NSArray *groups = [self packageToGroupListWithPosts:postGroups];
//                    for (NSInteger i = 0; i < [groups count]; i++) {
//                        NSArray *groupPosts = [groups[i] allValues][0];
//                        WXYSectionData *data = [[WXYSectionData alloc] initWithGroupList:groupPosts];
//                        if (data) {
//                            [subGroup addObject:data];
//                        }
//                    }
//                    if (_isFirstRequest) {
//                        [self.articleListArray addObjectsFromArray:subGroup];
//                    }else{
//                        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [subGroup count])];
//                        [self.articleListArray insertObjects:subGroup atIndexes:set];
//                    }
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //刷新列表
//                        [_tableView reloadData];
//                        if ([self.articleListArray count] > 0) {
//                            NSIndexPath *indexPath;
//                            if (_isFirstRequest) {
//                                indexPath = [NSIndexPath indexPathForRow:[self.articleListArray count] - 1 inSection:0];
//                            }else{
//                                if ([subGroup count] < [self.articleListArray count]) {
//                                    indexPath = [NSIndexPath indexPathForRow:[subGroup count] inSection:0];
//                                }else{
//                                    indexPath = [NSIndexPath indexPathForRow:[self.articleListArray count] - 1 inSection:0];
//                                }
//                            }
////                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_isFirstRequest ? [self.articleListArray count] - 1 : [subGroup count]) inSection:0];
//                            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:_isFirstRequest ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:NO];
//                        }
//                        [_tableView.header endRefreshing];
//                        if (!hasMore) {
//                            [_tableView.header setHidden:YES];
//                        }
//                        if (_isFirstRequest) {
//                            _isFirstRequest = NO;
//                        }
//                        //刷新空白信息
//                        BOOL isEmpty = [self.articleListArray count] > 0 ? NO : YES;
//                        [self updateEmptyDataImageStatus:isEmpty];
//                        //设置当前阅读最大id
//                        if (_isGardenSubscription) {
//                            [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_GARDEN_OFFICIAL_ACCOUNT_CLICKED];
//                            [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_GARDEN_OFFICIAL_ACCOUNT];
//                        }else{
//                            [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_LEARN_GARDEN_CLICKED];
//                            [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_LEARN_GARDEN];
//                        }
//                    });
//                });
//            }
//        }];
//        return;
//    }
//    
//    [[TXChatClient sharedInstance].learnGardenManager fetch_articleGroupByBeginId:maxId completed:^(NSError *error, NSArray<TXPBArticleGroup *> *groupArray, BOOL hasMore) {
//
//        if (error) {
//            [self showFailedHudWithError:error];
//            DDLogDebug(@"获取postType:%@ 请求error:%@",@(TXHomePostType_Learngarden),error);
//            [_tableView.header endRefreshing];
//            //刷新空白信息
//            BOOL isEmpty = [self.articleListArray count] > 0 ? NO : YES;
//            [self updateEmptyDataImageStatus:isEmpty];
//        }else{
//            //数据适配器
//            NSMutableArray *groups = [NSMutableArray array];
//            for(TXPBArticleGroup *group in groupArray){
//                NSMutableArray *subGroup = [NSMutableArray array];
//                for(TXPBArticleAbstract *tb in group.abstract){
//                    TXPost *txPost = [[TXPost alloc] init];
//                    txPost.groupId = group.id;
//                    txPost.postId = tb.id;
//                    txPost.isRead = YES;
//                    txPost.title = tb.title;
//                    txPost.summary = tb.content;
//                    txPost.content = @"";
//                    txPost.coverImageUrl = tb.titleImgUrl;
//                    txPost.createdOn = group.createOn;
//                    txPost.postType = TXPBPostTypeLerngarden;
//                    txPost.postUrl = tb.detailUrl;
//                    txPost.shareUrl = tb.shareUrl;
//                    [subGroup addObject:txPost];
//                }
//                [groups addObject:subGroup];
//            };
//            
//            //处理数据并刷新列表
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSMutableArray *subGroup = [NSMutableArray array];
//                if (_isFirstRequest) {
//                    self.articleListArray = [NSMutableArray array];
//                }
////                NSArray *groups = [self packageToGroupListWithPosts:newArr];
//                for (NSInteger i = 0; i < [groups count]; i++) {
////                    NSArray *groupPosts = [groups[i] allValues][0];
//                    NSArray *groupPosts = groups[i];
//                    WXYSectionData *data = [[WXYSectionData alloc] initWithGroupList:groupPosts];
//                    if (data) {
//                        [subGroup addObject:data];
//                    }
//                }
//                if (_isFirstRequest) {
//                    [self.articleListArray addObjectsFromArray:subGroup];
//                }else{
//                    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [subGroup count])];
//                    [self.articleListArray insertObjects:subGroup atIndexes:set];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //刷新列表   18711219277
//                    [_tableView reloadData];
//                    if ([self.articleListArray count] > 0) {
//                        NSIndexPath *indexPath;
//                        if (_isFirstRequest) {
//                            indexPath = [NSIndexPath indexPathForRow:[self.articleListArray count] - 1 inSection:0];
//                        }else{
//                            if ([subGroup count] < [self.articleListArray count]) {
//                                indexPath = [NSIndexPath indexPathForRow:[subGroup count] inSection:0];
//                            }else{
//                                indexPath = [NSIndexPath indexPathForRow:[self.articleListArray count] - 1 inSection:0];
//                            }
//                        }
////                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_isFirstRequest ? [self.articleListArray count] - 1 : [subGroup count]) inSection:0];
//                        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:_isFirstRequest ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop animated:NO];
//                    }
//                    [_tableView.header endRefreshing];
//                    if (!hasMore) {
//                        [_tableView.header setHidden:YES];
//                    }
//                    if (_isFirstRequest) {
//                        _isFirstRequest = NO;
//                    }
//                    //刷新空白信息
//                    BOOL isEmpty = [self.articleListArray count] > 0 ? NO : YES;
//                    [self updateEmptyDataImageStatus:isEmpty];
//                    //设置当前阅读最大id
//                    if (_isGardenSubscription) {
//                        [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_GARDEN_OFFICIAL_ACCOUNT_CLICKED];
//                        [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_GARDEN_OFFICIAL_ACCOUNT];
//                    }else{
//                        [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_LEARN_GARDEN_CLICKED];
//                        [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_LEARN_GARDEN];
//                    }
//                });
//            });
//        }
//    }];
//
//}
//获取本地数据
//- (void)fetchLocalPostGroupListWithMaxId:(int64_t)maxId
//{
//    DDLogDebug(@"getPosts");
//    NSError *error = nil;
//    TXUser *user = [[TXChatClient sharedInstance] getCurrentUser:nil];
//    if (!user) {
//        return;
//    }
//    NSArray *postGroups = [[TXChatClient sharedInstance].postManager queryPosts:(TXPBPostType)TXHomePostType_Learngarden maxPostId:maxId gardenId:_isGardenSubscription ? user.gardenId : 0 count:20 error:&error];
//    //    NSArray *postGroups = [[TXChatClient sharedInstance] getPosts:(TXPBPostType)TXHomePostType_Learngarden maxPostId:maxId count:20 error:&error];
//    //    NSLog(@"本地list:%@",posts);
//    
//    if (error) {
//        DDLogDebug(@"获取postType:%@ 请求error:%@",@(TXHomePostType_Learngarden),error);
//        //        [_tableView.header endRefreshing];
//        //添加空白标示
//        [self addEmptyDataImage:NO showMessage:@"暂无信息"];
//        [self updateEmptyDataImageStatus:YES];
//    }else{
//        //处理数据并刷新列表
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            self.articleListArray = [NSMutableArray array];
//            NSArray *groups = [self packageToGroupListWithPosts:postGroups];
//            //反转一下
//            NSArray *reverseArray = groups.reverseObjectEnumerator.allObjects;
//            for (NSInteger i = 0; i < [reverseArray count]; i++) {
//                NSArray *groupPosts = [reverseArray[i] allValues][0];
//                WXYSectionData *data = [[WXYSectionData alloc] initWithGroupList:groupPosts];
//                if (data) {
//                    [self.articleListArray addObject:data];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //刷新列表
//                [_tableView reloadData];
//                //                [_tableView.header endRefreshing];
//                if ([self.articleListArray count] > 0) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.articleListArray count] - 1 inSection:0];
//                    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//                //刷新空白信息
//                BOOL isEmpty = [self.articleListArray count] > 0 ? NO : YES;
//                if (isEmpty) {
//                    [self addEmptyDataImage:NO showMessage:@"暂无信息"];
//                    //拉取微学园
////                    [_tableView.header beginRefreshing];
//                }else{
//                    //设置当前阅读最大id
//                    if (_isGardenSubscription) {
//                        [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_GARDEN_OFFICIAL_ACCOUNT_CLICKED];
//                        [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_GARDEN_OFFICIAL_ACCOUNT];
//                    }else{
//                        [[TXChatClient sharedInstance] setUserProfileValue:1 forKey:TX_PROFILE_KEY_LEARN_GARDEN_CLICKED];
//                        [[TXChatClient sharedInstance] setCountersDictionaryValue:0 forKey:TX_COUNT_LEARN_GARDEN];
//                    }
//                }
//                [self updateEmptyDataImageStatus:isEmpty];
//            });
//        });
//    }
//}
@end
