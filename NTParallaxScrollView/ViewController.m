//
//  ViewController.m
//  NTParallaxScrollView
//
//  Created by demon on 7/7/13.
//  Copyright (c) 2013 demon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor  =[UIColor whiteColor];
    
    UIImage * image0 = [UIImage imageNamed:@"demo0"];
    UIImage * image1 = [UIImage imageNamed:@"demo1"];
    UIImage * image2 = [UIImage imageNamed:@"demo2"];
    UIImage * image3 = [UIImage imageNamed:@"demo3"];
    NSArray * images = @[image0,image1,image2,image3];
    NTParallaxView * parallaxView = [[NTParallaxView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)
                                                            bgroundImages:images
                                                               dataSource:self
                                                                 delegate:self];
    [self.view addSubview:parallaxView];
    [parallaxView reloadData];
}
-(NSInteger)numberOfSectionsInParallaxView:(NTParallaxView *)parallaxView
{
    return 4;
}

-(NSInteger)parallaxView:(NTParallaxView *)parallaxView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)parallaxView:(NTParallaxView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)parallaxView:(NTParallaxView *)parallaxView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)parallaxView:(NTParallaxView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

static NSString * identifyCell = @"identify";
-(UITableViewCell*)parallaxView:(NTParallaxView *)parallaxView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [parallaxView dequeueReusableCellWithIdentifier:identifyCell];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifyCell];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"page:%d",indexPath.row];
    return cell;
}

-(CGFloat)parallaxViewBackWindowHeight
{
    return 200;
}


-(UIView*)parallaxView:(NTParallaxView *)parallaxView
viewForHeaderInSection:(NSInteger)section
{
    UIView * header =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    header.backgroundColor = [UIColor redColor];
    return header;
}

-(UIView*)parallaxView:(NTParallaxView *)parallaxView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)parallaxView:(NTParallaxView *)parallaxView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@: click",indexPath);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
