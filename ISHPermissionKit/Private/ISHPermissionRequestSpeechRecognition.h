//
//  ISHPermissionRequestSpeechRecognition.h
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"

#ifdef ISHPermissionRequestSpeechEnabled

/**
 *  Permission request to acces the speech recognition
 *  APIs.
 *
 *  @sa ISHPermissionCategorySpeechRecognition
 */
@interface ISHPermissionRequestSpeechRecognition : ISHPermissionRequest

@end

#endif
