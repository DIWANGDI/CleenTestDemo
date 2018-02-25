//
//  ZZUIMacro.h
//  heardAidedPlatform
//
//  Created by guanglong on 2017/11/2.
//  Copyright © 2017年 WD. All rights reserved.
//

#ifndef ZZUIMacro_h
#define ZZUIMacro_h



#pragma mark - Frame & Bound

#define FRAME_L(view) (view.frame.origin.x)
#define FRAME_R(view) (view.frame.origin.x+view.frame.size.width)
#define FRAME_T(view) (view.frame.origin.y)
#define FRAME_B(view) (view.frame.origin.y+view.frame.size.height)
#define FRAME_W(view) (view.frame.size.width)
#define FRAME_H(view) (view.frame.size.height)


#define BOUND_L(view) (view.bounds.origin.x)
#define BOUND_R(view) (view.bounds.origin.x+view.bounds.size.width)
#define BOUND_T(view) (view.bounds.origin.y)
#define BOUND_B(view) (view.bounds.origin.y+view.bounds.size.height)
#define BOUND_W(view) (view.bounds.size.width)
#define BOUND_H(view) (view.bounds.size.height)




#endif /* ZZUIMacro_h */
