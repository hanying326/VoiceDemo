//
//  Popuptable.m
//  VoiceDemo
//
//  Created by 寒影 on 10/07/2017.
//  Copyright © 2017 xiaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopupTable.h"
#import "Macros.h"
#import "RadioButton.h"
#import "LoadInfo.h"
#import "MyPopupController.h"
#import "AppDelegate.h"

@interface PopupTable()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, assign)NSInteger type;
@property (nonatomic, strong)NSMutableArray *loadInfos;
@property (nonatomic, strong)NSMutableArray *resultInfos;
@property (nonatomic, strong)MyPopupController *controller;
@property (nonatomic, strong)NSMutableArray *tableTitle;
@property (nonatomic, strong) NSMutableArray *arrCellSelect;
@property (nonatomic, strong) NSMutableDictionary *dlmweight;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSMutableArray *showData;
@property (nonatomic,strong)NSMutableArray *dic;
@property (nonatomic,strong)NSMutableArray *tipLabel;

@end

@implementation PopupTable

-(id)initWithType:(NSInteger )type controller:(MyPopupController *)controller{
    
    _controller = controller;
    if( [super init]){
        _type = type;
        _appDelegate = [[UIApplication sharedApplication] delegate];
        
        [self setDelegate:self];
        [self setDataSource:self];
        [self registerClass:UITableViewCell.class  forCellReuseIdentifier:@"Cell"];
        
        switch (self.type) {
            case VOICE_SETTING:
//                                _data =[NSMutableArray arrayWithObjects:@"Li-Mei",
//                                        @"Bin-Bin",
//                                        @"Sin-Ji",
//                                        @"Tian-Tian",
//                                        @"Mei-Jia",
//                                        @"Li-Li",
//                                        @"Susan",
//                                        @"Li-sa",
//                                        nil];
                
                _data =[NSMutableArray arrayWithObjects:@"ST_FEMALE",
                        @"ST_MALE",nil];
                _buttons = [NSMutableArray arrayWithCapacity:8];
                break;
                
            case LANG_SETTING:
                
                _data =[NSMutableArray arrayWithObjects:@"普通话",
                        @"上海话",nil];
                _buttons = [NSMutableArray arrayWithCapacity:2];
                break;
                
            case SIM_SWITCH:
                
                _data =[NSMutableArray arrayWithObjects:@"简体中文",
                        @"繁体中文",nil];
                
                _buttons = [NSMutableArray arrayWithCapacity:2];
                break;
                
            case ADDR_SETTING:
                _data =[NSMutableArray arrayWithObjects:@"地址",nil];
                break;
                
            case ARGU_SETTING:
                
                _data =[NSMutableArray arrayWithObjects:_appDelegate.APPKEY,
                        _appDelegate.APPSECRET,
                        _appDelegate.PLATFORM,
                        _appDelegate.USERID,nil];
                
                _showData =[NSMutableArray arrayWithObjects:@"请输入APPKEY",
                            @"请输入APPSECRET",
                            @"请输入PALTFORM",
                            @"请输入USERID",nil];
                
                _buttons = [NSMutableArray arrayWithCapacity:8];
                 _tipLabel = [NSMutableArray arrayWithCapacity:4];
                
                
                break;
                
            case ADDR_SETTING_ASK:
                _data =[NSMutableArray arrayWithObjects:_appDelegate.RECADDR,
                        _appDelegate.ASKADDR,
                        _appDelegate.TTSADDRF,
                        nil];
                
                _showData =[NSMutableArray arrayWithObjects:@"请输入语音识别地址",
                            @"请输入语义识别地址",
                            @"请输入语音播报地址",
                            nil];
                
                
                  _tipLabel = [NSMutableArray arrayWithCapacity:3];
                
                _buttons = [NSMutableArray arrayWithCapacity:6];
                break;
                
            case MODEL_SETTING:
                _tableTitle =[NSMutableArray arrayWithObjects:@"词",
                              @"句子",
                              nil];
                
                _resultInfos = [[NSMutableArray alloc]init];
                [self  fillModelSettingData];
                
                _buttons = [[NSMutableArray alloc]init];
                _senButtons = [[NSMutableArray alloc]init];
                _dlmweight = [[NSMutableDictionary alloc]init];
                break;
                
            case ARGU_SETTING_FORREC:
                
                _data =[NSMutableArray arrayWithObjects:_appDelegate.APPKEYREC,
                        _appDelegate.APPSECRETREC,
                        nil];
                
                _showData =[NSMutableArray arrayWithObjects:@"请输入appKey",
                            @"请输入appSecret",
                            nil];
                
                   _tipLabel = [NSMutableArray arrayWithCapacity:2];
                _buttons = [NSMutableArray arrayWithCapacity:4];
                
                break;
                
            default:
                break;
        }
    }
    [self setScrollEnabled:YES];
    self.userInteractionEnabled = YES;
    return self;
}

-(void)loadData:(NSInteger)type{
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)contentTable numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (_type == MODEL_SETTING){
        if(section == 0){
            return  [_wordLoadinfos count];
        }
        else {
            return  [_senLoadInfos count];
        }
    }
    
    else {
        result = _data.count;
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)contentTable cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section, indexPath.row];
    //    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld", indexPath.row];
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [contentTable cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextMessageCell"];
    }
    
    //    UITableViewCell *cell = [contentTable dequeueReusableCellWithIdentifier:cellIdentifier];
    //     UITableViewCell *cell = [contentTable cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CGFloat width = WIDTH_SCREEN - 8*PADDING;
    
    if( _type == ADDR_SETTING){
        
        UITextField *addrInput = [[UITextField alloc] initWithFrame:CGRectMake(15,5,width, 30)];
        addrInput.borderStyle = UITextBorderStyleNone;
        addrInput.layer.borderColor = [BORDER_RED CGColor];
        [addrInput setDelegate:self];
        [addrInput.window makeKeyAndVisible];
        [addrInput setEnabled:YES];
        [addrInput setUserInteractionEnabled:YES];
        [addrInput setDelegate:self];
        
        [cell addSubview:addrInput];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,29, width, 1)];
        lineView.backgroundColor = BORDER_RED;
        [addrInput addSubview:lineView];
        
        if([_controller.controller.title isEqual:@"语音合成"]){
            _controller.synthAddr = addrInput;
            addrInput.text =_appDelegate.TTSADDR;
        }
        
        else{
            _controller.rtAddr = addrInput;
            addrInput.text =_appDelegate.WSADDR;
            
        }
    }
    
    if (_type == LANG_SETTING){
        
        NSString * title = [_data objectAtIndex:indexPath.row];
        CGRect btnRect = CGRectMake(20,5, width, 30);
        
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
        btn.tag = indexPath.row;
        cell.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [_buttons addObject:btn];
        if(indexPath.row == 0){
            btn.selected = YES;
        }
    }
    
    
    if(_type == VOICE_SETTING){
        
        NSString * title = [_data objectAtIndex:indexPath.row];
        CGRect btnRect = CGRectMake(20,5, width, 30);
        
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
        btn.tag = indexPath.row;
        cell.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [_buttons addObject:btn];
        
//        if(indexPath.row == 0){
//            btn.selected = YES;
//        }
        
        if([_controller.controller.title isEqual:@"语音合成"]){
            
            if (indexPath.row == 0 && [_appDelegate.VOICEFORTTS isEqualToString:@"ST_FEMALE"]){
                 btn.selected = YES;
            }
            
            else if (indexPath.row == 1 && [_appDelegate.VOICEFORTTS isEqualToString:@"ST_MALE"]){
                 btn.selected = YES;
            }
        }
        
        else {
            
            if (indexPath.row == 0 && [_appDelegate.VOICE isEqualToString:@"ST_FEMALE"]){
                btn.selected = YES;
                
            }
            
            else if (indexPath.row == 1 && [_appDelegate.VOICE isEqualToString:@"ST_MALE"]){
                btn.selected = YES;
            }
        }
    }
    
    if(_type == ARGU_SETTING){
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(PADDING,4,width, 10)];
        tip.text = [_showData objectAtIndex:indexPath.row];
        tip.font =[UIFont systemFontOfSize:10];
        tip.textColor = POPUP_RED;
        tip.tag = indexPath.row;
         [cell addSubview:tip];
        
        [_tipLabel addObject:tip];
        
        UITextField *addrInput = [[UITextField alloc] initWithFrame:CGRectMake(20,20,width, 25)];
        addrInput.borderStyle = UITextBorderStyleNone;
        addrInput.layer.borderColor = [BORDER_RED CGColor];
        [addrInput setDelegate:self];
        [addrInput.window makeKeyAndVisible];
        [addrInput setEnabled:YES];
        [addrInput setUserInteractionEnabled:YES];
        addrInput.tag = indexPath.row;
        addrInput.font = [UIFont systemFontOfSize:14];
        NSString *content =[_data objectAtIndex:indexPath.row];
        
        if(content.length > 0 ){
            addrInput.text =content;
                        tip.hidden = NO;
        }
        
        else {
            addrInput.placeholder = [_showData objectAtIndex:indexPath.row];
                        tip.hidden = YES;
        }
        
        [_buttons addObject:addrInput];
        
//        addrInput.backgroundColor = [UIColor yellowColor];
        
        [cell addSubview:addrInput];
//
        addrInput.delegate = self;
        
        [addrInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,30, width, 1)];
        if(indexPath.row == 0){
            lineView.backgroundColor = POPUP_RED;
        }
        
        else {
            lineView.backgroundColor = POPUP_GRAY;
        }
        
        lineView.tag = indexPath.row+4;
        [_buttons addObject:lineView];
        
        //         [addrInput addSubview:tip];
        [addrInput addSubview:lineView];
        
        if(indexPath.row ==0){
            _controller.appKey = addrInput;
        }
        
        if(indexPath.row ==1){
            _controller.appSecret = addrInput;
//            [cell setBackgroundColor:[UIColor blueColor]];
        }
        
        if(indexPath.row ==2){
            _controller.platform = addrInput;
        }
        
        if(indexPath.row ==3){
            _controller.userId = addrInput;
        }
    }
    
    if (_type == ARGU_SETTING_FORREC){
        
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(PADDING,4,width, 10)];
        tip.text = [_showData objectAtIndex:indexPath.row];
        tip.font =[UIFont systemFontOfSize:10];
        tip.textColor = POPUP_RED;
        tip.tag = indexPath.row;
        [cell addSubview:tip];
        
        
        [_tipLabel addObject:tip];
        
        UITextField *addrInput = [[UITextField alloc] initWithFrame:CGRectMake(20,20,width, 25)];
        addrInput.borderStyle = UITextBorderStyleNone;
        addrInput.layer.borderColor = [BORDER_RED CGColor];
        [addrInput setDelegate:self];
        [addrInput.window makeKeyAndVisible];
        [addrInput setEnabled:YES];
        [addrInput setUserInteractionEnabled:YES];
        addrInput.tag = indexPath.row;
        addrInput.font = [UIFont systemFontOfSize:14];
        
        NSString *content =[_data objectAtIndex:indexPath.row];
        
        if(content.length > 0 ){
            addrInput.text =content;
                        tip.hidden = NO;
        }
        
        else {
            addrInput.placeholder = [_showData objectAtIndex:indexPath.row];
                        tip.hidden = YES;
        }
        
        [_buttons addObject:addrInput];
        [cell addSubview:addrInput];
        
        addrInput.delegate = self;
        
        [addrInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,30, width, 1)];
        if(indexPath.row == 0){
            lineView.backgroundColor = POPUP_RED;
        }
        
        else {
            lineView.backgroundColor = POPUP_GRAY;
        }
        
        lineView.tag = indexPath.row+2;
        [_buttons addObject:lineView];
        
        [addrInput addSubview:lineView];
        
        if(indexPath.row ==0){
            _controller.appKeyRec = addrInput;
        }
        
        if(indexPath.row ==1){
            _controller.appSecretRec = addrInput;
        }
    }
    
    if(_type == ADDR_SETTING_ASK){
        
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(PADDING,4,width, 10)];
        tip.text = [_showData objectAtIndex:indexPath.row];
        tip.font =[UIFont systemFontOfSize:10];
        tip.textColor = POPUP_RED;
        tip.tag = indexPath.row;
        [cell addSubview:tip];
        
        [_tipLabel addObject:tip];
        
        UITextField *addrInput = [[UITextField alloc] initWithFrame:CGRectMake(20,20,width, 25)];
        addrInput.borderStyle = UITextBorderStyleNone;
        addrInput.layer.borderColor = [BORDER_RED CGColor];
        //        addrInput.layer.borderWidth = 1.0;
        [addrInput setDelegate:self];
        [addrInput.window makeKeyAndVisible];
        [addrInput setEnabled:YES];
        [addrInput setUserInteractionEnabled:YES];
        
        addrInput.tag = indexPath.row;
        addrInput.font = [UIFont systemFontOfSize:14];
        
        NSString *content =[_data objectAtIndex:indexPath.row];
        
        if(content.length > 0 ){
            addrInput.text =content;
            tip.hidden = NO;
            
        }
        
        else {
            addrInput.placeholder = [_showData objectAtIndex:indexPath.row];
            tip.hidden = YES;
        }
        
        //        addrInput.text =[_data objectAtIndex:indexPath.row];
        //        addrInput.placeholder = [_data objectAtIndex:indexPath.row];
        addrInput.delegate = self;
        
        [cell addSubview:addrInput];
        [_buttons addObject:addrInput];
        
        [self bringSubviewToFront:addrInput];
        
        [addrInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,30, width, 1)];
        lineView.tag = indexPath.row+3;
        
        if(indexPath.row == 0){
            
            lineView.backgroundColor = POPUP_RED;
        }
        
        else {
            
            lineView.backgroundColor = POPUP_GRAY;
            
        }
        
        [_buttons addObject:lineView];
        [addrInput addSubview:lineView];
        
        if(indexPath.row ==0){
            _controller.recAddr = addrInput;
        }
        
        else if(indexPath.row ==1){
            
            _controller.askAddr = addrInput;
            
        }
        
        else if(indexPath.row ==2){
            
            _controller.ttsAddr = addrInput;
        }
    }
    
    if(_type == SIM_SWITCH){
        
        NSString * title = [_data objectAtIndex:indexPath.row];
        CGRect btnRect = CGRectMake(20,5, 200, 30);
        
        RadioButton* btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
        btn.tag = indexPath.row;
        
        cell.contentView.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [_buttons addObject:btn];
        
        if(indexPath.row == 0){
            btn.selected = YES;
        }
    }
    
    if(_type == MODEL_SETTING){
        
        
        
        UIImage *nolImage = [UIImage imageNamed:@"Voice_popup_icon3_nol"];
        nolImage = [self scaleImage:nolImage toScale:1.2];
        
        
        UIImage *preImage = [UIImage imageNamed:@"Voice_popup_icon3_pre"];
        preImage = [self scaleImage:preImage toScale:1.2];
        
        if(indexPath.section == 0){
            
            LoadInfo *info = [_wordLoadinfos objectAtIndex:indexPath.row];
            
            NSString * title = info.filename;
            
            
            NSString *showTitle;
            
            
            if([title hasSuffix:@".json"]){
                showTitle = [title substringToIndex:title.length-5];
            }
            
            if([title hasSuffix:@".xml"]){
                showTitle = [title substringToIndex:title.length-4];
            }
            
            
            //          RadioButton* checkbox = [[RadioButton alloc] initWithFrame:CGRectMake(PADDING, PADDING, WIDTH_SCREEN-8*PADDING, 2*PADDING)];
            UIButton* checkbox = [[UIButton alloc] init];
            [checkbox setTitle: showTitle forState:UIControlStateNormal];
            [checkbox setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            checkbox.titleLabel.numberOfLines = 0;
            checkbox.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            [checkbox setImage:nolImage forState:UIControlStateNormal];
            [checkbox setImage:preImage forState:UIControlStateSelected];
            checkbox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
            checkbox.tag = indexPath.row;
            
            [checkbox addTarget:self action:@selector(onCheckBoxClicked:) forControlEvents:UIControlEventTouchDown];
            
            if([[_arrCellSelect objectAtIndex:indexPath.row] isEqual:@(YES)]){
                checkbox.selected  = true;
            }
            
            
            if([[_appDelegate.wordsetModelSetting allKeys]containsObject:title]){
                checkbox.selected  = true;
            }
            
            [cell addSubview:checkbox];
            [_buttons addObject:checkbox];
            
            checkbox.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:-PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:-PADDING].active = YES;
        }
        
        else {
            NSInteger wordCount = [_wordLoadinfos count];
            NSInteger row = indexPath.row + wordCount;
            //            NSString * title = [[_data objectAtIndex:indexPath.row + wordCount]objectForKey:@"filename"] ;
            
            LoadInfo *info = [_senLoadInfos objectAtIndex:indexPath.row];
            NSString * title = info.filename;
            
              NSString *showTitle;
            
            
            if([title hasSuffix:@".json"]){
                showTitle = [title substringToIndex:title.length-5];
            }
            
            if([title hasSuffix:@".xml"]){
                showTitle = [title substringToIndex:title.length-4];
            }
            
            
            UIButton* checkbox = [[UIButton alloc] init];
            [checkbox setTitle: showTitle forState:UIControlStateNormal];
            [checkbox setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            checkbox.titleLabel.numberOfLines = 0;
            checkbox.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            
            
            
            
            
            
            [checkbox setImage:nolImage forState:UIControlStateNormal];
            [checkbox setImage:preImage forState:UIControlStateSelected];
            checkbox.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            checkbox.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
            checkbox.tag = indexPath.row;
            [checkbox addTarget:self action:@selector(onSenCheckBoxClicked:) forControlEvents:UIControlEventTouchDown];
            
            if([[_arrCellSelect objectAtIndex:row] isEqual:@(YES)]){
                checkbox.selected  = true;
            }
            
            if([[_appDelegate.sentenceModelSetting allKeys]containsObject:title]){
                checkbox.selected  = true;
            }
            
            LoadInfo *tempDic = [_appDelegate.sentenceModelSetting objectForKey:title];
            
            NSString *weight = tempDic.dlmWeight;
            
            [cell addSubview:checkbox];
            [_senButtons addObject:checkbox];
            
            checkbox.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:checkbox
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:-PADDING].active = YES;
            
            NSMutableArray *select = [_dlmweightSelect objectForKey:[NSString stringWithFormat: @"%d", indexPath.row]];
            
            RadioButton *lowest = [[RadioButton alloc]init];
            [lowest setTitle:@"lowest" forState:UIControlStateNormal];
            [lowest setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            lowest.titleLabel.font = [UIFont systemFontOfSize:15];
            [lowest setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
            [lowest setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
            [lowest addTarget:self action:@selector(ondlmButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
            lowest.tag = checkbox.tag;
            
            if ([weight isEqualToString:@"lowest"]){
                
                lowest.selected = YES;
                [select replaceObjectAtIndex:0 withObject:@(YES)];
            }
            
            lowest.userInteractionEnabled = YES;
            
            RadioButton *low = [[RadioButton alloc]init];
            [low setTitle:@"low" forState:UIControlStateNormal];
            [low setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            low.titleLabel.font = [UIFont systemFontOfSize:15];
            [low setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
            [low setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
            [low addTarget:self action:@selector(ondlmButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
            low.tag = checkbox.tag +100;
            
            if ([weight isEqualToString:@"low"]){
                
                low.selected = YES;
                [select replaceObjectAtIndex:1 withObject:@(YES)];
            }
            
            RadioButton *medium = [[RadioButton alloc]init];
            [medium setTitle:@"medium" forState:UIControlStateNormal];
            [medium setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            medium.titleLabel.font = [UIFont systemFontOfSize:15];
            [medium setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
            [medium setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
            [medium addTarget:self action:@selector(ondlmButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
            medium.tag = checkbox.tag +200;
            if ([weight isEqualToString:@"medium"]){
                
                medium.selected = YES;
                [select replaceObjectAtIndex:2 withObject:@(YES)];
            }
            
            RadioButton *high = [[RadioButton alloc]init];
            [high setTitle:@"high" forState:UIControlStateNormal];
            [high setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            high.titleLabel.font = [UIFont systemFontOfSize:15];
            [high setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
            [high setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
            [high addTarget:self action:@selector(ondlmButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
            high.tag = checkbox.tag +300;
            if ([weight isEqualToString:@"high"]){
                
                high.selected = YES;
                [select replaceObjectAtIndex:3 withObject:@(YES)];
            }
            
            RadioButton *highest = [[RadioButton alloc]init];
            [highest setTitle:@"highest" forState:UIControlStateNormal];
            [highest setTitleColor:POP_TEXT_COLOR forState:UIControlStateNormal];
            highest.titleLabel.font = [UIFont systemFontOfSize:15];
            [highest setImage:[UIImage imageNamed:@"Voice_popup_icon2_nol"] forState:UIControlStateNormal];
            [highest setImage:[UIImage imageNamed:@"Voice_popup_icon2_pre"] forState:UIControlStateSelected];
            [highest addTarget:self action:@selector(ondlmButtonValueChanged:) forControlEvents:UIControlEventTouchDown];
            
            highest.tag = checkbox.tag +400;
            
            if ([weight isEqualToString:@"highest"]){
                
                highest.selected = YES;
                [select replaceObjectAtIndex:4 withObject:@(YES)];
            }
            
            if([[select objectAtIndex:0] isEqual:@(YES)]){
                lowest.selected = YES;
            }
            
            if([[select objectAtIndex:1] isEqual:@(YES)]){
                low.selected = YES;
            }
            
            if([[select objectAtIndex:2] isEqual:@(YES)]){
                medium.selected = YES;
            }
            
            if([[select objectAtIndex:3] isEqual:@(YES)]){
                high.selected = YES;
            }
            
            if([[select objectAtIndex:4] isEqual:@(YES)]){
                highest.selected = YES;
            }
            
            [cell addSubview:lowest];
            [cell addSubview:low];
            [cell addSubview:medium];
            [cell addSubview:high];
            [cell addSubview:highest];
            
            lowest.translatesAutoresizingMaskIntoConstraints = NO;
            low.translatesAutoresizingMaskIntoConstraints = NO;
            medium.translatesAutoresizingMaskIntoConstraints = NO;
            high.translatesAutoresizingMaskIntoConstraints = NO;
            highest.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint constraintWithItem:lowest
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:2*PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:lowest
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:checkbox
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:low
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lowest
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:low
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:checkbox
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:medium
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:low
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            
            [NSLayoutConstraint constraintWithItem:medium
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:checkbox
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            
            [NSLayoutConstraint constraintWithItem:high
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:2*PADDING].active = YES;
            
            
            [NSLayoutConstraint constraintWithItem:high
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lowest
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:highest
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:low
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            [NSLayoutConstraint constraintWithItem:highest
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:high
                                         attribute:NSLayoutAttributeRight
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
            NSMutableArray *btns = [[NSMutableArray alloc]init];
            
            [btns addObject:lowest];
            [btns addObject:low];
            [btns addObject:medium];
            [btns addObject:high];
            [btns addObject:highest];
            
            [_dlmweight setObject:btns forKey: [NSString stringWithFormat: @"%d", checkbox.tag]];
            
            CGRect lineSize =    CGRectMake(0,0,width, 1);
            UIView *lineView = [[UIView alloc]initWithFrame:lineSize];
            lineView.backgroundColor = POPUP_GRAY;
            [cell addSubview:lineView];
            
              lineView.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint constraintWithItem:lineView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:high
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:2].active = YES;
            
            [NSLayoutConstraint constraintWithItem:lineView
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:cell
                                         attribute:NSLayoutAttributeLeft
                                        multiplier:1.0
                                          constant:PADDING].active = YES;
            
        }
    }
    
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_type == MODEL_SETTING){
        return 2;
    }
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.tableTitle objectAtIndex:section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(_type == MODEL_SETTING){
        return 40;
    }
    
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1 ){
        return  100;
    }
    
    else if(_type == MODEL_SETTING || _type == ARGU_SETTING || _type == ADDR_SETTING_ASK || _type == ARGU_SETTING_FORREC){
        return  50;
    }
    return  40;
}


-(CGFloat )tableHeight{
    
    CGFloat height = _data.count * 45.0;
    if (_type == MODEL_SETTING){
        height = HEIGHT_SCREEN -150 - 100;
    }
    
    if (_type == ARGU_SETTING || _type == ADDR_SETTING_ASK || _type == ARGU_SETTING_FORREC){
        
        height = _data.count * 52.0;
    }
    return height;
}


-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    if(!sender.selected) {
        sender.selected = YES;
        
        for (RadioButton *button in _buttons ){
            button.selected = NO;
        }
        sender.selected = YES;
    }
}

-(void) ondlmButtonValueChanged:(RadioButton*)sender
{
    
    NSMutableArray *select = [_dlmweightSelect objectForKey:[NSString stringWithFormat: @"%d", sender.tag%100]];
    NSMutableArray *btns = [_dlmweight objectForKey:[NSString stringWithFormat: @"%d", sender.tag%100]];
    
    for (RadioButton *button in btns ){
        
        button.selected = NO;
        [select replaceObjectAtIndex:button.tag/100 withObject:@(NO)];
        
    }
    sender.selected = YES;
    [select replaceObjectAtIndex:sender.tag/100 withObject:@(YES)];
}


-(void) onCheckBoxClicked:(RadioButton *)sender{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        
        [_arrCellSelect replaceObjectAtIndex:sender.tag withObject:@(YES)];
        UIButton *button = [_buttons objectAtIndex:sender.tag];
        button.selected = YES;
    }
    else {
        [_arrCellSelect replaceObjectAtIndex:sender.tag withObject:@(NO)];
        UIButton *button = [_buttons objectAtIndex:sender.tag];
        button.selected = NO;
    }
}

-(void) onSenCheckBoxClicked:(RadioButton *)sender{
    sender.selected = !sender.selected;
    
    if(sender.selected){
        [_arrCellSelect replaceObjectAtIndex:sender.tag + [_wordLoadinfos count] withObject:@(YES)];
        UIButton *button = [_senButtons objectAtIndex:sender.tag];
        button.selected = YES;
        
        
        
        NSMutableArray *select = [_dlmweightSelect objectForKey:[NSString stringWithFormat: @"%d", sender.tag]];
        NSMutableArray *btns = [_dlmweight objectForKey:[NSString stringWithFormat: @"%d", sender.tag]];
        
        
        
          NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@(NO),@(NO),@(NO),@(NO),@(NO), nil];
        
        
        if ([select isEqual: array]){
            
            [select replaceObjectAtIndex:2 withObject:@(YES)];
            
            
            UIButton *ub = [btns objectAtIndex:2];
            
            ub.selected = YES;
            
            
            
        }
        
        
    }
    else {
        [_arrCellSelect replaceObjectAtIndex:sender.tag + [_wordLoadinfos count] withObject:@(NO)];
        UIButton *button = [_senButtons objectAtIndex:sender.tag];
        button.selected = NO;
    }
}


-(void)fillModelSettingData{
    
    _dic = _controller.modelSettingDic;
    
    _data =[[NSMutableArray alloc]init];
    _loadInfos = [[NSMutableArray alloc]init];
    
    _wordLoadinfos = [[NSMutableArray alloc]init];
    _senLoadInfos = [[NSMutableArray alloc]init];
    
    //    NSDictionary *dicsss = _appDelegate.allModelSetting;
    
    for (NSDictionary *dic in _dic){
        
        NSString *type =[dic valueForKey:@"type"] ;
        
        if([type containsString:@"wordset"]){
            
            LoadInfo *info = [[LoadInfo alloc]init];
            info.id = [dic valueForKey:@"id"];
            info.loadType = [dic valueForKey:@"type"];
            info.filename = [dic valueForKey:@"filename"];
            [_wordLoadinfos addObject:info];
            [_data addObject:info];
        }
        
        else {
            LoadInfo *info = [[LoadInfo alloc]init];
            info.id = [dic valueForKey:@"id"];
            info.loadType = [dic valueForKey:@"type"];
            info.filename = [dic valueForKey:@"filename"];
            [_senLoadInfos addObject:info];
            [_data addObject:info];
        }
    }
    
    _arrCellSelect = [[NSMutableArray alloc]init];
    for (int i =0 ; i< _data.count; i++) {
        [_arrCellSelect addObject:@(NO)];
    }
    
    _dlmweightSelect = [NSMutableDictionary dictionary];
    
    for (int i =0 ; i< [_senLoadInfos count]; i++) {
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@(NO),@(NO),@(NO),@(NO),@(NO), nil];
        [_dlmweightSelect setObject:array forKey:[NSString stringWithFormat: @"%d", i]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(NSMutableArray *)getResultLoadinfos {
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    [ result addObject:[_loadInfos objectAtIndex:0]];
    return result;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _controller.alertView.frame = CGRectMake( _controller.alertView.frame.origin.x, _controller.alertView.frame.origin.y - 110,  _controller.alertView.frame.size.width,  _controller.alertView.frame.size.height);
    
    NSInteger index = textField.tag;
    
    if(_type == ADDR_SETTING_ASK){
        
        for (UIView *field in _buttons ){
            
            if (field.tag == index+3){
                field.backgroundColor = POPUP_RED;
            }
            
            else if(field.tag >2){
                field.backgroundColor = POPUP_GRAY;
            }
        }
    }
    
    
    if(_type == ARGU_SETTING){
        
        for (UIView *field in _buttons ){
            
            if (field.tag == index+4){
                field.backgroundColor = POPUP_RED;
            }
            
            else if(field.tag >3){
                field.backgroundColor = POPUP_GRAY;
            }
        }
    }
    
    
    if(_type == ARGU_SETTING_FORREC){
        
        for (UIView *field in _buttons ){
            
            if (field.tag == index+2){
                field.backgroundColor = POPUP_RED;
            }
            
            else if(field.tag >1){
                field.backgroundColor = POPUP_GRAY;
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _controller.alertView.frame = CGRectMake( _controller.alertView.frame.origin.x,  _controller.alertView.frame.origin.y +110,  _controller.alertView.frame.size.width,  _controller.alertView.frame.size.height);
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    
     UILabel *label = [_tipLabel objectAtIndex:theTextField.tag];
    if (theTextField.text.length > 0){
        label.hidden = NO;
    }
    
    else  {
        theTextField.placeholder = [_showData objectAtIndex:theTextField.tag];
        label.hidden = YES;
    }
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
                                [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
                                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                
                                return scaledImage;
                                
                                }


@end














