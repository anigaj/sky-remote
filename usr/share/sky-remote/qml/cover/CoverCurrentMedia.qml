import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0

Item 
{
    id: coverCurrentMedia
    property variant details
    property alias loadedItem: componentLoader.item
    property bool isStandby: true
        
    Connections
    {
        target: coverPage
        onStatusChanged: if(status == Cover.Active) updateTimer.start()
        onCoverChannelChanged: updateTimer.start() 
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
                    if(result["isApp"])
                    {
                         loadedItem.text =  result["appName"]
                        coverCurrentMedia.isStandby = false
                    }
                    else coverCurrentMedia.isStandby = true 
                }
                else if(result["isOff"]) 
                {
                    pageStack.push("../pages/ConnectSkyBox.qml",{},PageStackAction.Immediate)  
                    app.activate()
                }
                else
                {
                    coverCurrentMedia.isStandby = false
                    details = result
                    componentLoader.sourceComponent =mediaContent     
                }
            })
            
             if(coverPage.pressBack) 
            {
                python.call('helper.pressButton',["backup"],function() {console.log("backup pressed")})
                coverPage.pressBack = false
            } 
        }
    }

    Component 
    {
        id: standby
        Label
        {
            id: standbyText
            height :coverCurrentMedia.height
            width: coverCurrentMedia.width
            font.pixelSize: Theme.fontSizeLarge
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
             //% "Sky Q Box is on standby"
             text: qsTrId("sky-standby") 
        }
    }
    
    Component 
    {
        id: mediaContent
        Item
        {            
            height :coverCurrentMedia.height
            width: coverCurrentMedia.width
            
            Image
            {
                id: mediaIcon
                height: coverCurrentMedia.height/4
                width: height
                source: coverCurrentMedia.details["imageUrl"]
                anchors
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    topMargin: Theme.paddingLarge
                    top: parent.top        
                }    
            }
            
            Label
            {
               id: channelNo
               height :mediaIcon/2
               anchors 
               {
                   left: mediaIcon.right
                   leftMargin: Theme.horizontalPageMargin
                    topMargin: Theme.paddingLarge
                    top: parent.top
                }
                font.pixelSize: Theme.fontSizeMedium
                text:coverCurrentMedia.details["channelno"]         
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
                text: coverCurrentMedia.details["live"] ? liveTxt : recTxt
            }
            Label
            {
                id: channelName
                height :mediaIcon/2
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                    top: mediaIcon.bottom
                }
                font.pixelSize: Theme.fontSizeMedium
                text:coverCurrentMedia.details["channel"]         
            }
            
            Label
             {
                id: serEp
                height :mediaIcon/2
                anchors     
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    top: channelName.bottom
                    topMargin: -Theme.paddingSmall
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                //% "Se."
                property string sTxt:qsTrId("sky-season-abv")
                //% "Ep."
                property string eTxt:qsTrId("sky-episode-abv")
                text:sTxt +": "+ (coverCurrentMedia.details["season"]===undefined ?  " " : coverCurrentMedia.details["season"]) +" " +eTxt + ": " +   (coverCurrentMedia.details["episode"]===undefined ? " " : coverCurrentMedia.details["episode"])
            }         
    
            Label
            {
                id: programmeName 
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                    top: serEp.bottom
                }
                font.pixelSize: Theme.fontSizeMedium
                maximumLineCount: 2
                wrapMode: Text.WrapAnywhere
                text:coverCurrentMedia.details["title"]         
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
                    topMargin: -Theme.paddingSmall
                }
                font.pixelSize: Theme.fontSizeSmall            
                color: Theme.highlightColor
                //% "Start time"
                text:(coverCurrentMedia.details["live"] ? qsTrId("sky-start-time") +": ":qsTrId("sky-recorded") +": ") + getTime(coverCurrentMedia.details["starttime"],coverCurrentMedia.details["live"])         
            }
            
            Label
            {
                id: endTime
                visible: coverCurrentMedia.details["live"]
                height :mediaIcon/2
                width: parent/2
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    top: startTime.bottom
                    topMargin: -Theme.paddingSmall
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                //% "End time"
                text:qsTrId("sky-end-time")+": " + getTime(coverCurrentMedia.details["endtime"],coverCurrentMedia.details["live"])         
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
