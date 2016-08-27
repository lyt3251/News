//
//  ShareActionManager.m
//  UMengShare
//
//  Created by shengxin on 16/6/1.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import "ShareActionManager.h"
#import "UMSocial.h"
//#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UmengShareMarco.h"
#import "UMSocialData.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "MBProgressHUD.h"

#define shareDefaultImage @"80.png"//微信分享占位图 90x90 135x135
@interface ShareActionManager()<UMSocialUIDelegate>
{
    ShareActionModel *iShareModel;
    SharePicModel *iSharePicModel;
    UMSocialSnsPlatform *iCurrentSnsPlatform;
}

@property (nonatomic, weak) UIViewController *iFromVC;
@property (nonatomic, strong) NSString *shareDefaultImageName;
@end

@implementation ShareActionManager

#pragma mark - public
+ (instancetype)shareInstance{
    static ShareActionManager *obj=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ShareActionManager alloc] init];
        obj.shareDefaultImageName = @"share_appIcon";
    });
    return obj;
}

- (void)htmlShareToPlatformType:(kSharePlatformType)shareType
         FromViewController:(UIViewController*)vc
          andPostShareModel:(ShareActionModel*)shareModel{
    _iFromVC = vc;
    iShareModel = shareModel;
    switch (shareType) {
        case kSharePlatformWXSceneSession:
        {
            [self shareToWXWithScene:WXSceneSession];
        }
            break;
        case kSharePlatformWXSceneTimeline:
        {
            [self shareToWXWithScene:WXSceneTimeline];
        }
            break;
        case kShareCopyLink:
        {
            [self shareToCopyLink];
        }
            break;
        case kShareOpenUrlWithSafari:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iShareModel.shareUrl]];
        }
            break;
        default:
            [self shareWithUMToOtherPlatformType:shareType];
            break;
    }
}
//这块写的比较乱，有时间优化下
- (void)picShareToPlatformType:(kSharePlatformType)shareType
            FromViewController:(UIViewController*)vc
             andPostShareModel:(SharePicModel*)shareModel{
    _iFromVC = vc;
    iSharePicModel = shareModel;
     switch (shareType) {
         case kSharePlatformWXSceneSession:
         {
             [self shareToPicWXWithScene:WXSceneSession];
         }
             break;
         case kSharePlatformWXSceneTimeline:
         {
             [self shareToPicWXWithScene:WXSceneTimeline];
         }
        break;
         case kSharePlatformQQFriends:
         {
             UMSocialData *customData = [UMSocialData defaultData];
             //            customData.title = shareModel.name;
             //             customData.shareText = shareModel.name;
             customData.shareImage = shareModel.image;
             customData.commentImage = shareModel.image;
             
             UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
             iCurrentSnsPlatform = snsPlatform;
             [UMSocialControllerService defaultControllerService].socialUIDelegate=self;
             [UMSocialControllerService defaultControllerService].socialData = customData;
             
             [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
             [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.title = shareModel.name;
             snsPlatform.snsClickHandler(_iFromVC,[UMSocialControllerService defaultControllerService],YES);
         }
        break;
         default:
             
        break;
     }
}

#pragma mark - 微信分享
- (void)shareToWXWithScene:(int)shareScene{
    if (![WXApi isWXAppInstalled]) {
//       @"请先安装微信客户端"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先安装微信客户端" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = [self getCustonWXMessage];
    req.scene = shareScene;
    [WXApi sendReq:req];
}

- (void)shareToPicWXWithScene:(int)shareScene{
    if (![WXApi isWXAppInstalled]) {
        //       @"请先安装微信客户端"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先安装微信客户端" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = [self getCustonPicWXMessage];
    req.scene = shareScene;
    [WXApi sendReq:req];
}

- (WXMediaMessage*)getCustonWXMessage{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = iShareModel.titleStr;
    message.description = iShareModel.commentStr;
    if (iShareModel.imageLocal!=nil) {
        if (iShareModel.imageLocal.size.width>120||iShareModel.imageLocal.size.height>120) {
            [message setThumbImage:[self weixinSharedImageWithImage:iShareModel.imageLocal]];
        }else{
            [message setThumbImage:iShareModel.imageLocal];
        }
    }else{
        [message setThumbImage:[self weixinSharedImageWithURL:iShareModel.wxImageUrl]];
    }
    WXWebpageObject *ext = [WXWebpageObject object];   //message mediaObject（分享链接）
    ext.webpageUrl = iShareModel.shareUrl;
    message.mediaObject = ext;
    return message;
}

- (WXMediaMessage*)getCustonPicWXMessage{
    WXMediaMessage *message = [WXMediaMessage message];
    WXImageObject *ext = [WXImageObject object];
    [message setThumbImage:[self picweixinSharedImageWithImage:(iSharePicModel.image)]];
    ext.imageData = UIImageJPEGRepresentation(iSharePicModel.image,1.0);
    message.mediaObject = ext;
    return message;
}

- (UIImage*)weixinSharedImageWithImage:(UIImage *)image{
    if (image) {
        CGSize size = CGSizeMake(4 * 40.0f, 3 * 40.0f);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat w = 100.0f;
        CGFloat h = 100.0f;
        CGFloat y = (size.height - h) / 2.0f;
        CGFloat x = (size.width - w) / 2.0f;
        CGRect rect = CGRectMake(x, y, w, h);
        UIImage *sharedImage =[UIImage imageWithCGImage:(__bridge CGImageRef)(CFBridgingRelease(CGImageCreateWithImageInRect([scaledImage CGImage], rect)))];
        if (sharedImage) {
            return sharedImage;
        } else {
            return [UIImage imageNamed:_shareDefaultImageName];
        }
    }
    else{
        return [UIImage imageNamed:_shareDefaultImageName];
    }
    
}

- (UIImage *)weixinSharedImageWithURL:(NSString *)urlString{
    if (urlString) {
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        if (!image) {
            return [UIImage imageNamed:_shareDefaultImageName];
        }
        CGSize size = CGSizeMake(4 * 40.0f, 3 * 40.0f);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat w = 100.0f;
        CGFloat h = 100.0f;
        CGFloat y = (size.height - h) / 2.0f;
        CGFloat x = (size.width - w) / 2.0f;
        CGRect rect = CGRectMake(x, y, w, h);
        UIImage *sharedImage =[UIImage imageWithCGImage:(__bridge CGImageRef)(CFBridgingRelease(CGImageCreateWithImageInRect([scaledImage CGImage], rect)))];
        if (sharedImage) {
            return sharedImage;
        } else {
            return [UIImage imageNamed:_shareDefaultImageName];
        }
    } else{
        return [UIImage imageNamed:_shareDefaultImageName];
    }
}

- (UIImage*)picweixinSharedImageWithImage:(UIImage *)image{
    if (image) {
        CGSize size;
        if (image.size.width>image.size.height) {
            size = CGSizeMake(100,image.size.height*100/image.size.width);
        }else{
            size = CGSizeMake(image.size.width*100/(image.size.height),100);
        }
        
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat w = 100.0f;
        CGFloat h = 100.0f;
        CGFloat y = 0;
        CGFloat x = 0;
        CGRect rect = CGRectMake(x, y, w, h);
        UIImage *sharedImage =[UIImage imageWithCGImage:(__bridge CGImageRef)(CFBridgingRelease(CGImageCreateWithImageInRect([scaledImage CGImage], rect)))];
        if (sharedImage) {
            return sharedImage;
        } else {
            return [UIImage imageNamed:_shareDefaultImageName];
        }
    } else{
        return [UIImage imageNamed:_shareDefaultImageName];
    }
}

#pragma mark - 复制
- (void)shareToCopyLink{
    //复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:iShareModel.shareUrl];
    //@"复制成功"
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"复制成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - 其他平台
- (void)shareWithUMToOtherPlatformType:(kSharePlatformType)shareType{
    if(![QQApiInterface isQQInstalled] && (shareType == kSharePlatformQQFriends || shareType == kSharePlatformQQZone)){
//      @"请先安装QQ客户端"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先安装QQ客户端" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSString *snsName = nil;
    switch (shareType) {
        case kSharePlatformSinaWeibo :
            snsName = UMShareToSina;
            break;
        case kSharePlatformQQFriends :
            snsName = UMShareToQQ;
            break;
        case kSharePlatformQQZone :
            snsName = UMShareToQzone;
            break;
        case kSharePlatformEmail :
            snsName = UMShareToEmail;
            break;
        default:
            break;
    }

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    iCurrentSnsPlatform = snsPlatform;
    [UMSocialControllerService defaultControllerService].socialUIDelegate=self;
    
    [UMSocialControllerService defaultControllerService].socialData = [self getCustonUMSocialDataWithPlatformType:shareType];
    //为QQ空间单独设置
    if (shareType == kSharePlatformQQZone) {

        [UMSocialControllerService defaultControllerService].socialData.extConfig.qzoneData.url = [NSString stringWithFormat:@"%@",iShareModel.shareUrl];
        [UMSocialControllerService defaultControllerService].socialData.extConfig.qzoneData.title=[NSString stringWithFormat:@"%@",iShareModel.titleStr];
    }
    //为QQ单独设置
    if (shareType == kSharePlatformQQFriends) {
        
        [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.url = [NSString stringWithFormat:@"%@",iShareModel.shareUrl];
        [UMSocialControllerService defaultControllerService].socialData.extConfig.qqData.title=[NSString stringWithFormat:@"%@",iShareModel.titleStr];
    }
   
    snsPlatform.snsClickHandler(_iFromVC,[UMSocialControllerService defaultControllerService],YES);
}

//不同平台,不同栏目对分享的文字和图片进行自定义
- (UMSocialData*)getCustonUMSocialDataWithPlatformType:(kSharePlatformType)shareType
{
    UMSocialData *customData = [UMSocialData defaultData];
    customData.title = iShareModel.titleStr;
    //新浪和腾讯的分享文字（微博）
    if (shareType == kSharePlatformSinaWeibo){
        customData.shareText =[NSString stringWithFormat:@"%@:%@",iShareModel.titleStr,iShareModel.shareUrl];
        if (iShareModel.shareImageUrl){
            customData.shareImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iShareModel.shareImageUrl]]];
        }
        else{
            customData.shareImage= [UIImage imageNamed:_shareDefaultImageName];
        }
    }
    else{
//        customData.shareText = [NSString stringWithFormat:@"%@",iShareModel.commentStr];
        //设置分享图片
        if (shareType==kSharePlatformEmail){
            
            if (iShareModel.wxImageUrl){
                customData.shareImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iShareModel.wxImageUrl]]];
                
            }
            else
            {
                customData.shareImage= [UIImage imageNamed:_shareDefaultImageName];
            }
        }
        else{
            if (iShareModel.shareImageUrl){
                customData.shareImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iShareModel.shareImageUrl]]];
            }
            else{
                if (iShareModel.imageLocal) {
                    customData.shareImage= iShareModel.imageLocal;
                }else{
                    customData.shareImage= [UIImage imageNamed:_shareDefaultImageName];
                }
            }
        }
        
    }
    return customData;
}

#pragma mark - UMSocialUIDelegate(分享完成回调)
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //4.4.2 通知H5页面是否分享成功
    BOOL isSharedSuccess;
    if(response.responseCode == 200){
        isSharedSuccess = YES;
    }else{
        isSharedSuccess = NO;
    }
    if (isSharedSuccess==YES) {
 
        [self showTipView:_iFromVC.view andText:@"分享成功"];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sharedSuccessOrNotNotification"
//                                                        object:@(isSharedSuccess)];

    NSString *platformType = nil;
    //分享失败 提示
    if ([[response.data objectForKey:[[response.data allKeys] objectAtIndex:0]]isKindOfClass:[NSDictionary class]]) {
        if ([[[response.data objectForKey:[[response.data allKeys] objectAtIndex:0]] objectForKey:@"st"]integerValue]==5024) {
            
            platformType=[[response.data allKeys] objectAtIndex:0];//得到分享到的平台名
            [self unOauthWithType:platformType];
            
            if ([UMSocialControllerService defaultControllerService].socialUIDelegate) {
                NSString *strMessage=nil;
                if ([platformType isEqualToString:UMShareToSina]) {
                    strMessage=[NSString stringWithFormat:@"请重新绑定新浪微博后再分享"];
                }
                else if([platformType isEqualToString:UMShareToTencent]){
                    strMessage=[NSString stringWithFormat:@"请重新绑定腾讯微博后再分享"];
                }
                else if([platformType isEqualToString:UMShareToQzone]){
                    strMessage=[NSString stringWithFormat:@"请重新绑定QQ空间后再分享"];
                }
                else{
                    strMessage=[NSString stringWithFormat:@"请重新绑定后再分享"];
                }
                
                [self  showTipView:_iFromVC.view andText:strMessage];
            }else{
                [self  showTipView:_iFromVC.view andText:@"分享失败"];
            }
        }
        else{
            [UMSocialControllerService defaultControllerService].socialUIDelegate=nil;
        }
    }
//    //邮件分享发送通知
//    if (iCurrentSnsPlatform == [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToEmail]) {
//    }
}

//分享完成后,将授权取消
- (void)unOauthWithType:(NSString *)platformType{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {;
    }];
}

#pragma mark -MB
#pragma mark -MBProgressHUD
- (void)showTipView:(UIView *)contentView andText:(NSString*)aTipText
{
    [self removeHud:contentView];
    MBProgressHUD *aHud = [MBProgressHUD showHUDAddedTo:contentView animated:YES];
    aHud.mode = MBProgressHUDModeIndeterminate;
    aHud.labelText = aTipText;
    aHud.margin = 10.f;
    aHud.yOffset = 10.f;
    aHud.removeFromSuperViewOnHide = YES;
    [aHud hide:YES afterDelay:1.0];
}

- (void)removeHud:(UIView *)contentView
{
    for (UIView *view in contentView.subviews)
    {
        if ([view isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *aHud = (MBProgressHUD *)view;
            [aHud hide:YES];
        }
    }
}


@end
