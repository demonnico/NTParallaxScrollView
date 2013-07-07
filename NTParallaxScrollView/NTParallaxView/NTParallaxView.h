//
//  NTParallxView.h
//  ParallaxScorllView
//
//  Created by demon on 7/6/13.
//  Copyright (c) 2013 demon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTParallaxView;

@protocol NTParallaxViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInParallaxView:(NTParallaxView *)parallaxView;
- (NSInteger)parallaxView:(NTParallaxView *)parallaxView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)parallaxView:(NTParallaxView *)parallaxView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(UIView*)parallaxView:(NTParallaxView *)parallaxView viewForFooterInSection:(NSInteger)section;
-(UIView*)parallaxView:(NTParallaxView *)parallaxView viewForHeaderInSection:(NSInteger)section;

@end

@protocol NTParallaxViewDelegate <NSObject>

@required
- (void)parallaxView:(NTParallaxView *)parallaxView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)parallaxView:(NTParallaxView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)parallaxView:(NTParallaxView *)tableView heightForFooterInSection:(NSInteger)section;
- (CGFloat)parallaxView:(NTParallaxView*)parallaxView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)parallaxViewBackWindowHeight;

@end

@protocol NTParallaxViewProtocol <NSObject>

-(id)initWithFrame:(CGRect)frame
     bgroundImages:(NSArray*)images
        dataSource:(id<NTParallaxViewDataSource>)dataSource
          delegate:(id<NTParallaxViewDelegate>)deleagte;

-(void)reloadData;
-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)dequeueString;

@end


@interface NTParallaxView : UIView
<NTParallaxViewProtocol,
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate>

@property (nonatomic,weak)id<NTParallaxViewDataSource>dataSource;
@property (nonatomic,weak)id<NTParallaxViewDelegate> delegate;
@end
