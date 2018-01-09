//
//  SpeechEndPointDetector.h
//  iknowapp
//
//  Created by Peter Liu on 10/18/12.
//  Copyright (c) 2012 xiaoi. All rights reserved.
//


#ifndef SPEECHENDPOINTDETECTOR_H
#define SPEECHENDPOINTDETECTOR_H

#include <iostream>
#include <list>

class SpeechEndPointDetectorListener
{
public:
    virtual void onActiveSpeechEndPointBegin(void *param, int begin_length) {}
    virtual void onActiveSpeechEndPointEnd(void *param, int end_length) {}
private:
    
};

class SpeechEndPointDetector
{
public:
    SpeechEndPointDetector(int windowSampleCount,
                           int sampleRate,
                           int bitsPerSample,
                           float highShortEnergyValue = 0.1, //0.1
                           float lowShortEnergyValue = 0.03, //
                           float highShortEnergyCrossZeroRate = 4, //4
                           float lowShortEnergyCrossZeroRate = 4, //3
                           float shortEnergyCrossZeroDelta = 0.03,
                           int beginCountNum = 5,
                           int endCountNum = 10); //40
    
    void BeginDetect(SpeechEndPointDetectorListener *listener, void* param);
    void PushOneWindowSamples(const char* pSamplesBuf, int bufLen, unsigned int index);
    void EndDetect();
private:
    void CheckCurZeroRate();
    void CheckActive();
private:
    unsigned int        m_curIndex;
    unsigned int        m_curEndPointBeginIndex;
    unsigned int        m_curEndPointEndIndex;
    int                 m_WindowSampleCount;
    int                 m_SampleRate;
    int                 m_BitsPerSample;
    float               m_PreSample;
    float               m_CurSample;
    float               m_curE;
    float               m_Eh, m_El, m_Zh, m_Zl, m_Delta, m_BeginNum, m_EndNum;
    bool                m_isBegin;
    int                 m_curBeginNum;
    int                 m_curEndNum;
    int                 m_curZeroCrossNum;
    SpeechEndPointDetectorListener *m_pCurListener;
    void                *m_param;
    bool                m_isInitialize;
};

#endif /* SPEECHENDPOINTDETECTOR_H */
