//
//  PopupTable.h
//  VoiceDemo
//
//  Created by 寒影 on 10/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#ifndef PopupTable_h
#define PopupTable_h


#endif /* PopupTable_h */

#import <UIKit/UIKit.h>
#import "MyPopupController.h"

@interface PopupTable : UITableView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *data;
@property (nonatomic, strong)NSMutableArray *buttons;

@property (nonatomic, strong)NSMutableArray *senButtons;


@property (nonatomic, strong)NSMutableArray *wordLoadinfos;
@property (nonatomic, strong)NSMutableArray *senLoadInfos;

@property (nonatomic, strong) NSMutableDictionary *dlmweightSelect;

-(id)initWithType:(NSInteger )type controller:(MyPopupController *)controller;

-(void)loadData:(NSInteger)type;

-(CGFloat )tableHeight;


@end
