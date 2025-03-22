//
//  Macros.h
//  ClubFlow
//
//  Created by Shea Cheese on 2025/3/22.
//

#ifndef Macros_h
#define Macros_h

// 屏幕尺寸
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 设备判断
#define iOS_IPhone ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define iOS_IPhoneX SCREEN_WIDTH >= 375.0f && SCREEN_HEIGHT >=812.0f&& iOS_IPhone

/*状态栏高度*/
#define STATUSBAR_HEIGHT (CGFloat)(iOS_IPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define NAVBAR_HEIGHT (44)
/*状态栏和导航栏总高度*/
#define NAVBAR_STATUSBAR_HEIGHT (CGFloat)(iOS_IPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define TABBAR_HEIGHT (CGFloat)(iOS_IPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define TOPBARSAFE_HEIGHT (CGFloat)(iOS_IPhoneX?(44.0):(0))
 /*底部安全区域远离高度*/
#define BOTTOMBARSAFE_HEIGHT (CGFloat)(iOS_IPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define TOPBARDIF_HEIGHT (CGFloat)(iOS_IPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define NAV_TABBAR_HEIGHT (NAVBAR_STATUSBAR_HEIGHT + TABBAR_HEIGHT)


#endif /* Macros_h */
