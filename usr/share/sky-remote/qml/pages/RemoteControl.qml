import QtQuick 2.5
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import org.nemomobile.configuration 1.0
import QtGraphicalEffects 1.0
Page 
{
    id: remotePage
    property QtObject _feedbackEffect
    property bool isActive: Qt.application.state == Qt.ApplicationActive
    property bool channel: false
    property bool isFwdRev: false
    property int pressCount: 0
    property bool pressBack: false
    
    ConfigurationGroup
    {
        id: skySettings
        path: "/apps/sky-remote"
        property bool autoPressBack: true 
    }
    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: remoteContent.height
        PullDownMenu
        {         
            MenuItem
            {
                id: details 
                //% "Sky Q box details" 
                text: qsTrId("sky-details")
                onClicked: pageStack.push(Qt.resolvedUrl("SkyDetails.qml"))
            }
            MenuItem
            {
                id: settings 
                //% "Settings" 
                text: qsTrId("sky-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("../settings/MainSettingsPage.qml"))
            }
        }
        Column
        {
            id: remoteContent
            width: parent.width
            spacing: Theme.paddingMedium
            
            PageHeader
            {
                //% "Remote Control"
                title: qsTrId("sky-remote-control")
            }
            Row
            {
                width: parent.width 
                Column
                {         
                    Item       
                    {
                        id: powerIconRect
                        height: powerIcon.height
                        width:  powerIcon.height

                        property bool isStandby: true
                        MouseArea
                        {
                            anchors.fill: parent
                            onPressed: {
                                if (_feedbackEffect) {
            _feedbackEffect.play()
                            }
                        }
                        onClicked: python.call('helper.pressButton',["power"],function() {
                                if(skySettings.autoPressBack) pressBack = true                    
                                powerIconRect.isStandby = !powerIconRect.isStandby
                                channel = !channel
                            })
                        } 
                    
                        Image
                        {
                            id: powerIcon
                            source:"image://theme/graphic-power-off"
                           visible: false
                        }
                        ColorOverlay
                        {
                            anchors.fill: powerIcon
                            source: powerIcon
                            color:powerIconRect.isStandby ? 'red' : 'green'
                        }
                    }
                    RemoteButton 
                    {
                        height:powerIconRect.height 
                        width: height
                        isIcon:true
                        source: "image://theme/icon-m-call-recording-on-light" 
                        onClicked: {
                            python.call('helper.pressButton',["record"],function() {})
                        
                        }
                    }
                }
                CurrentMedia
                {
                    height: powerIcon.height*2
                    width: parent.width - powerIcon.width
                }
            }
            Row 
            {
               width: parent.width 
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    isIcon:true
                    source: "r-rewind.png" 
                    onClicked: {
                        python.call('helper.pressButton',["rewind"],function() {})
                        isFwdRev = true
                    }
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    isIcon:true
                    source: "play-pause.png" 
                    onClicked:{ 
                        python.call('helper.pressPlayPause',[isFwdRev],function() {})
                        isFwdRev = false
                    }
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    isIcon:true
                    source: "f-forward.png" 
                    onClicked:{
                            python.call('helper.pressButton',["fastforward"],function() {})
                            isFwdRev = true
                        }
                }
            }
            Row 
            {
                width: parent.width 
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/4
                    isIcon:true
                    source: "image://theme/icon-m-back" 
                    onClicked: python.call('helper.pressButton',["backup"],function() {
                            channel = !channel
                        })
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/4
                    isIcon:true
                    source: "image://theme/icon-m-home" 
                    onClicked: python.call('helper.pressButton',["home"],function() {})
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/4
                    text: ("sky") 
                    onClicked: python.call('helper.pressButton',[text],function() {})
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/4
                    isIcon:true
                    source: "image://theme/icon-lock-more" 
                    onClicked: python.call('helper.pressButton',["sidebar"],function() {})
                }
            }
            Row 
            {
                width: parent.width 
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    text: "?"
                    onClicked: python.call('helper.pressButton',["help"],function() {})
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    isIcon:true
                    source: "image://theme/icon-m-search"  
                    onClicked: python.call('helper.pressButton',["search"],function() {})
                }
                RemoteButton 
                {
                    height:powerIconRect.height 
                    width:parent.width/3
                    isIcon:true
                    source: "image://theme/icon-m-about" 
                    onClicked: python.call('helper.pressButton',["i"],function() {})
                }
            }
            Row
            {
                width: parent.width
                Column
                {                  
                    width: parent.width/2                  
                    Grid
                    {
                        width: parent.width
                        columns: 3
                        Repeater 
                        {
                            model: 9
                            RemoteButton 
                            {
                                height:powerIconRect.height 
                                width:parent.width/3
                                text: (1 + index).toLocaleString()
                                onClicked: python.call('helper.pressButton',[text],function() {
                                    pressCount = pressCount + 1
                                    if(pressCount ==3) 
                                    {
                                        channel = !channel
                                        pressCount = 0
                                    }
                                    })
                            }
                        }
                    }
                    Row 
                    {
                        width: parent.width 
                        RemoteButton 
                        {
                            height:powerIconRect.height 
                            width:parent.width/3
                            isIcon:true
                            source: "image://theme/icon-m-down" 
                            onClicked: python.call('helper.pressButton',["channeldown"],function() {
                                channel = !channel
                                })
                        }
                        RemoteButton 
                        {
                            height:powerIconRect.height 
                            width:parent.width/3
                            text: (0).toLocaleString() 
                            onClicked: python.call('helper.pressButton',[text],function() {
                                pressCount = pressCount + 1
                                if(pressCount ==3) 
                                {
                                    channel = !channel
                                    pressCount = 0
                                }
                                })
                        }
                        RemoteButton 
                        {
                            height:powerIconRect.height 
                            width:parent.width/3
                            isIcon:true
                            source: "image://theme/icon-m-up" 
                            onClicked: python.call('helper.pressButton',["channelup"],function() {
                                channel = !channel
                                })
                        }
                    }
                }
                Column
                {                  
                    width: parent.width/2
                    Grid
                    {
                        width: parent.width
                        columns: 3
                        Repeater 
                        {
                            model: 9
                            ArrowButton 
                            {
                                height:powerIconRect.height 
                                width:parent.width/3                        
                                gridId: index.toLocaleString()
                                onClicked: python.call('helper.pressButton',[text],function() {
                            if(index==4) channel = !channel
                                    })
                            }
                        }
                    }
                    Grid
                    {
                        width: parent.width
                        columns: 4
                        Repeater 
                        {
                            model: 4
                            ColorDot 
                            {
                                height:powerIconRect.height 
                                width:parent.width/4                        
                                gridId: index.toLocaleString()
                                onClicked: python.call('helper.pressButton',[text],function() {})
                            }
                        }
                    }
                }
            } 
        }
    }
    Component.onCompleted:
    {
        _feedbackEffect = Qt.createQmlObject("import QtQuick 2.0; import QtFeedback 5.0; ThemeEffect { effect: ThemeEffect.PressWeak }",
                           remotePage, 'ThemeEffect');
    }
    onIsActiveChanged:
    {
        if(isActive)python.call('helper.getPowerStatus',[],function(result) {     
            powerIconRect.isStandby = (result == "STANDBY")
            channel = !channel
        })
    } 
}
