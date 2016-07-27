//
//  TXAsynRun.h
//  TXChat
//
//  Created by 陈爱彬 on 15/7/12.
//  Copyright (c) 2015年 lingiqngwan. All rights reserved.
//

typedef void(^TXBlockRun)(void);

void TXAsyncRun(TXBlockRun run);

void TXAsyncRunInMain(TXBlockRun run);

