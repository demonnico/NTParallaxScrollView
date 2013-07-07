//
//  NTParallxView.m
//  ParallaxScorllView
//
//  Created by demon on 7/6/13.
//  Copyright (c) 2013 demon. All rights reserved.
//

#import "NTParallaxView.h"

@interface NTParallaxView()

@property(nonatomic,strong) UITableView  * tableView;
@property(nonatomic,strong) UIScrollView * sv_transparent;
@property(nonatomic,strong) UIScrollView * sv_images;

@property(nonatomic,strong) NSArray *images;
@property(nonatomic,assign) CGFloat imageHeight;
@property(nonatomic,assign) CGFloat backWindowHeight;
@end

@implementation NTParallaxView

-(id)initWithFrame:(CGRect)frame
     bgroundImages:(NSArray *)images
        dataSource:(id<NTParallaxViewDataSource>)dataSource
          delegate:(id<NTParallaxViewDelegate>)deleagte
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.dataSource = dataSource;
        self.delegate   = deleagte;
        
        CGFloat windowWidth = frame.size.width;
        self.backWindowHeight= [_delegate parallaxViewBackWindowHeight];
        self.images = images;
        for (UIImage* image in  images)
        {
            int index = [images indexOfObject:image];
            if(!index)//the first image, we init the frame of _sv_images
            {
                self.imageHeight= image.size.height;
                self.sv_images = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                windowWidth,
                                                                                image.size.height)];
                [self addSubview:self.sv_images];
                self.sv_images.showsHorizontalScrollIndicator =NO;
            }
            CGFloat imageHeight = image.size.height;
            CGFloat imageYCenter = floorf((self.backWindowHeight -imageHeight) / 2.0)+imageHeight/2;
            UIImageView * iv = [[UIImageView alloc] initWithImage:image];
            iv.center =CGPointMake(index*windowWidth+windowWidth/2, imageYCenter);
            [self.sv_images addSubview:iv];
        }
        int imagePageNums = self.images.count;
        self.sv_images.contentSize = CGSizeMake(windowWidth*imagePageNums,
                                                self.sv_images.frame.size.height);
        
        CGRect sv_transparent_frame = CGRectMake(0,
                                                 0,
                                                 windowWidth,
                                                 _backWindowHeight);
        self.sv_transparent = [[UIScrollView alloc] initWithFrame:sv_transparent_frame];
        self.sv_transparent.contentSize = CGSizeMake(_sv_images.contentSize.width, _backWindowHeight);
        self.sv_transparent.showsHorizontalScrollIndicator = NO;
        self.sv_transparent.delegate    =self;
        self.sv_transparent.pagingEnabled =YES;
        self.sv_transparent.backgroundColor = [UIColor clearColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark NTParallaxViewProtocol Methods

-(UITableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)dequeueString
{
    return [self.tableView dequeueReusableCellWithIdentifier:dequeueString];
}

-(void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!section)
        return 1;
    return [_dataSource parallaxView:self numberOfRowsInSection:section-1];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [_dataSource numberOfSectionsInParallaxView:self]+1;
}

static NSString * identify =@"IdentifyForTableView";
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section)
    {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identify];
            cell.backgroundColor             = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle              = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:_sv_transparent];
        }
        return cell;
    }else{
        NSIndexPath *indexPathParallax  = [self reconstructIndexPath:indexPath];
        return [_dataSource parallaxView:self cellForRowAtIndexPath:indexPathParallax];
    }
}

-(NSIndexPath*)reconstructIndexPath:(NSIndexPath*)indexPath
{
    return [NSIndexPath indexPathForRow:indexPath.row
                              inSection:indexPath.section-1];
}

#pragma mark UITableViewDelegate Methods
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(!section)
        return 0;
    return [_delegate parallaxView:self
          heightForFooterInSection:section-1];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(!section)
        return 0;
    return [_delegate parallaxView:self
          heightForHeaderInSection:section-1];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section)
        return _backWindowHeight;
    NSIndexPath *indexPathParallax  = [self reconstructIndexPath:indexPath];
    return [_delegate parallaxView:self
           heightForRowAtIndexPath:indexPathParallax];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.section)
        return;
    NSIndexPath * indexPathReconstruct = [self reconstructIndexPath:indexPath];
    [_delegate parallaxView:self
    didSelectRowAtIndexPath:indexPathReconstruct];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(!section)
        return nil;
    return [_dataSource parallaxView:self
              viewForFooterInSection:section-1];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!section)
        return nil;
    return [_dataSource parallaxView:self
              viewForHeaderInSection:section-1];
}

#pragma mark UIScrollViewDelegte Method

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset   = _tableView.contentOffset.y;
    CGFloat xOffset   = _sv_transparent.contentOffset.x;
    CGFloat threshold = _imageHeight-_backWindowHeight;
    
    if (yOffset > -threshold && yOffset < 0) {
        //UITableView往下滑动的时候
        _sv_images.contentOffset = CGPointMake(xOffset, floorf(yOffset / 2.0));
    } else if (yOffset < 0) {
        //UItableView往下滑动拖拽(sv_images出界的情况)
        _tableView.contentOffset =CGPointMake(0, -threshold);
    } else {
        //UITableView往上滑动的时候
        _sv_images.contentOffset = CGPointMake(xOffset, yOffset);
    }
}

@end
