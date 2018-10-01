//
//  KJTapGestureRecognizer.h
//
//
//  Created by Kevin Jett on 8/27/18.
//  Copyright © 2018 Kevin Jett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KJTapGestureRecognizer : UITapGestureRecognizer

@property (nonatomic, strong) NSObject *data;
@property (nonatomic, strong) UIViewController *viewController;

@end
