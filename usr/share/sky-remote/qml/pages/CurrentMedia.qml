import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0

Item 
{
    id: currentMedia
    property variant details
    property alias loadedItem: componentLoader.item
        
    Connections
    {
        target: remotePage
        onChannelChanged: updateTimer.start()
    }
    
    Timer
    {
        id: updateTimer
        repeat: false
        interval: 2000
        
        onTriggered:   {
            componentLoader.sourceComponent  = undefined
            python.call('helper.getCurrentMedia',[],function(result) {               
                if (result["isStandby"] || result["isApp"])
                {                 
                    componentLoader.sourceComponent =standby                                
                    if(result["isApp"]) loadedItem.text =  result["appName"]
                }
                else if(result["isOff"]) pageStack.replace(Qt.resolvedUrl("ConnectSkyBox.qml"))  
                else
                {
                    details = result
                    componentLoader.sourceComponent =mediaContent     
                }
            })
             if(remotePage.pressBack) 
            {
                python.call('helper.pressButton',["backup"],function() {console.log("backup pressed")})
                remotePage.pressBack = false
            } 
        }
    }

    Component 
    {
        id: standby
        Label
        {
            id: standbyText
            height :currentMedia.height
            width: currentMedia.width
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
       
             //% "Sky Q Box is on standby"
             text: qsTrId("sky-standby") 
        }
    }
    
    Component 
    {
        id: mediaContent
        Item
        {            
            height :currentMedia.height
            width: currentMedia.width
            
            Image
            {
                id: mediaIcon
                height: currentMedia.height/2
                width: height
                source: currentMedia.details["imageUrl"]
                anchors
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    top: parent.top        
                }    
            }
            
            Label
             {
                id: isLive
                height :mediaIcon/2
                anchors 
               {
                    left: mediaIcon.right
                    leftMargin: Theme.horizontalPageMargin
                    top: channelNo.bottom
                }
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall                
                
                //% "live"
                property string liveTxt: qsTrId("sky-live") 
                //% "recorded"
                property string recTxt: qsTrId("sky-recorded")
                text: currentMedia.details["live"] ? liveTxt : recTxt
            }
            
            Label
             {
                id: serEp
                height :mediaIcon/2
                anchors     
                {
                    left: isLive.right
                    leftMargin: Theme.horizontalPageMargin
                    top: channelNo.bottom
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                //% "Season"
                property string sTxt:qsTrId("sky-season")
                //% "Episode"
                property string eTxt:qsTrId("sky-episode")
                text:sTxt +": "+ (currentMedia.details["season"]===undefined ?  " " : currentMedia.details["season"]) +" " +eTxt + ": " +   (currentMedia.details["episode"]===undefined ? " " : currentMedia.details["episode"])
            } 
        
            Label
            {
               id: channelNo
               height :mediaIcon/2
               anchors 
               {
                   left: mediaIcon.right
                   leftMargin: Theme.horizontalPageMargin
                }
                font.pixelSize: Theme.fontSizeLarge
                text:currentMedia.details["channelno"]         
            }         
        
            Label
            {
                id: channelName
                height :mediaIcon/2
                anchors 
                {
                    left: channelNo.right
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                    top: parent.top
                }
                font.pixelSize: Theme.fontSizeLarge
                text:currentMedia.details["channel"]         
            }
            
            Label
            {
                id: programmeName
                height :mediaIcon/2
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                    top: mediaIcon.bottom
                }
                font.pixelSize: Theme.fontSizeLarge
                truncationMode: TruncationMode.Fade
                text:currentMedia.details["title"]         
            }
      
            Label
            {
                id: startTime
                height :mediaIcon/2
                width: parent/2
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    top: programmeName.bottom
                }
                font.pixelSize: Theme.fontSizeSmall            
                color: Theme.highlightColor
                //% "Start time"
                text:(currentMedia.details["live"] ? qsTrId("sky-start-time") +": ":qsTrId("sky-recorded") +": ") + getTime(currentMedia.details["starttime"],currentMedia.details["live"])         
            }
            
            Label
            {
                id: endTime
                visible: currentMedia.details["live"]
                height :mediaIcon/2
                width: parent/2
                anchors 
                {
                    left: startTime.right
                    leftMargin: Theme.paddingSmall
                    top: programmeName.bottom
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                //% "End time"
                text:qsTrId("sky-end-time")+": " + getTime(currentMedia.details["endtime"],currentMedia.details["live"])         
            }
        }
    }
    
    Loader
    {
        id: componentLoader
    }
    
    function getTime(timeText, withoutDate)
    {
        var d = new Date(timeText)
        if (withoutDate) return  Format.formatDate(d,Formatter.TimeValue)
        else
         return  Qt.formatDate(d, "ddd")  + " " +  Qt.formatDate(d)  + " "+  Format.formatDate(d,Formatter.TimeValue)
         
    }  
}
