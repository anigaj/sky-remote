#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#  Copyright (C) 2015 Jolla Ltd.
#  Contact: Jussi Pakkanen <jussi.pakkanen@jolla.com>
#  All rights reserved.
#
#  You may use this file under the terms of BSD license as follows:
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the Jolla Ltd nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# This file demonstrates how to write a class that downloads data from the
# net, does heavy processing or some other operation that takes a long time.
# To keep the UI responsive we do the operations in a separate thread and
# send status updates via signals.

import pyotherside
import socket
import json

from pyskyqremote.skyq_remote import SkyQRemote 

boxIPAdd ="0.0.0.0"
sky =[]
channelDict =[]
channelList = []
channelKeys = []


def flatten_json(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out

def findSkyBox(timeOut):         
    global boxIPAdd
    global sky
    global channelList
    global channelDict
    global channelKeys   
    
    msg = ('M-SEARCH * HTTP/1.1\r\n' +
                    'HOST: 239.255.255.250:1900\r\n' +
                    'MAN: "ssdp:discover"\r\n' +
                    'MX: 1\r\n' +
                    'ST: ssdp:all\r\n' +
                    '\r\n')

    # Set up UDP socket
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    s.settimeout(timeOut)
    s.sendto(msg.encode('ASCII'), ("239.255.255.250",1900) )
 
    try:
        while True:
            data, addr = s.recvfrom(65507)
            msgReceived =data.decode('ASCII') 
            if("Sky" in msgReceived ):                                                                                                                        
                ipAdd =msgReceived[msgReceived.find("LOCATION"):msgReceived.find("OPT")]
                ipAdd =ipAdd[ipAdd.find("//")+2:ipAdd.find(":",ipAdd.find("//"))]
                boxIPAdd = ipAdd
                sky = SkyQRemote(boxIPAdd)
                
                channelDict = json.loads(sky.getChannelList().as_json())
                channelDict = flatten_json(channelDict["channels"])
                channelList = list(channelDict.values())
                channelKeys = list(channelDict.keys())              
                break 
    except socket.timeout:
        return False
    
    return True

def setSkyBoxIP(ipAdd):                                                                                
    global boxIPAdd
    global sky
    global channelList
    global channelDict
    global channelKeys

    try:
        boxIPAdd = ipAdd 
        sky = SkyQRemote(boxIPAdd)
        channelDict = json.loads(sky.getChannelList().as_json())
        channelDict = flatten_json(channelDict["channels"])
        channelList = list(channelDict.values())
        channelKeys = list(channelDict.keys())
    except:                                                                                                                    
        return False
    else:                                                                                                                        
        return True

def getSkyBoxIP():
    return boxIPAdd

def getPowerStatus():
    return sky.powerStatus()

def pressButton(button):                
    sky.press(button)

def pressPlayPause(isFwdRev):                
    status = sky.getCurrentState()
                                                                                   
    if(status == "PAUSED_PLAYBACK"):                                                                                                
        sky.press("pause") if isFwdRev else sky.press("play")
    else:                                                                                                    
        sky.press("play") if isFwdRev else sky.press("pause")

def getDetails():                
    data = json.loads(sky.getDeviceInformation().as_json())

    details = data["attributes"]
    detailsStr = "" 
    for key in details:
        detailsStr = detailsStr + key +": " + details[key] + "\n"
 
    return detailsStr 

def getCurrentMedia():                                                                                                                                                                
    try:                                                                                                                                                                    
        if(sky.powerStatus() == "ON"):                                                                                                                                                    
            app = sky.getActiveApplication() 
            if(app != "com.bskyb.epgui"):                                                                                                                                                        
                return  {"isApp":True, "isStandby": False, "appName":app, "isOff": False }

            tryCount = 0
            while True:
                try:                                                                                                                                                                                            
                    if(tryCount == 3):                                                                                                                                                                                                    
                        return  {"isApp":False, "isStandby": False,  "isOff": True }
                    tryCount = tryCount + 1

                    data = json.loads(sky.getCurrentMedia().as_json())
                    #print(data)
                    details = data["attributes"]
                    if(details["live"] ):            
                        sid = int(details["sid"])
                        currentTV = json.loads(sky.getCurrentLiveTVProgramme(sid).as_json())
                        currentTV = currentTV["attributes"]
                        a_dict = {"channel" : details["channel"]}
                        currentTV.update(a_dict)
                        currentTV["imageUrl"] = details["imageUrl"]
                    else:                                                                                                                                                                                    
                        pvrId = details["pvrId"]
                        currentTV = json.loads(sky.getRecording(pvrId).as_json())
                        currentTV = currentTV["attributes"]
                        a_dict = {"channel" : currentTV["channelname"]}
                        currentTV.update(a_dict)
                except:                                                                                                                                                                                                                        
                    continue
                else:                                                                                                                                                                                                                
                    break
            channelKey = channelKeys[channelList.index(currentTV["channel"])]
            channelKey = channelKey.replace("channelname","channelno")

            a_dict = {"channelno":channelDict[channelKey], "live": details["live"]}
            currentTV.update(a_dict)          
            return currentTV
        elif(sky.powerStatus() == "STANDBY"):                                                                                                                                                                                                                                                    
            return {"isApp":False, "isStandby": True, "isOff": False} 
        else:                                                                                                                                                                                                                                                                  
            return {"isApp":False, "isStandby": False, "isOff": True}
    except:                                                                                                                                                                                                                                                                                    
        return {"isApp":False, "isStandby": False, "isOff": True}  
