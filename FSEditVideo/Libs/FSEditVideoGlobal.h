//
//  FSEditVideoGlobal.h
//  FSEditVideo
//
//  Created by 燕来秋 on 2020/8/4.
//  Copyright © 2020 fanshij@163.com. All rights reserved.
//
/*
 
 AVAsset：素材库里的素材；
 AVAssetTrack：素材的轨道；
 AVMutableComposition ：一个用来合成视频的工程文件；
 AVMutableCompositionTrack ：工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材；
 AVMutableVideoCompositionLayerInstruction：视频轨道中的一个视频，可以缩放、旋转等；
 AVMutableVideoCompositionInstruction：一个视频轨道，包含了这个轨道上的所有视频素材；
 AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行；
 AVAssetExportSession：配置渲染参数并渲染。
 
 */

#import <FSJUtility/FSJUtilityGlobal.h>

#import "FSFrameMacro.h"
#import "FSColorMacro.h"

#import "FSCompoundTool.h"
#import "FSCameraConfig.h"

#import "FSTimeLine.h"
