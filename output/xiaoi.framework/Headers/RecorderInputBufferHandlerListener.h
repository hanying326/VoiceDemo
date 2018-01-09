//
//  RecorderInputBufferHandler.h
//  iknowapp
//
//  Created by Peter Liu on 2/1/13.
//  Copyright (c) 2013 xiaoi. All rights reserved.
//

#ifndef RECORDERINPUTBUFFERHANDLERLISTENER_H
#define RECORDERINPUTBUFFERHANDLERLISTENER_H

#include <iostream>

class RecorderInputBufferHandlerListener
{
public:
    virtual void OnInputBufferHandler(void *param, void *buffer, size_t bufferByteSize);
};


#endif 
