import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

CoverBackground 
{
    id: coverPage
    property bool coverChannel: false 
    property bool isFwdRev: false
    property bool pressBack: false
    anchors.fill: parent 
    
    ConfigurationGroup
    {
        id: skySettings
        path: "/apps/sky-remote"
        property bool autoPressBackCover: true
        property int coverRows: 3 
    }
    ConfigurationValue
    {
        id: coverButtons
        key: "/apps/sky-remote/coverButtons"
       defaultValue: [{"keypress1":"channeldown","imgdark1":"image://theme/icon-m-down","imglight1":"image://theme/icon-m-down","keypress2":"channelup" ,"imgdark2":"image://theme/icon-m-up" ,"imglight2":"image://theme/icon-m-up"},{"keypress1":"power","imgdark1":"image://theme/graphic-power-off","imglight1":"image://theme/graphic-power-off","keypress2":"playpause" ,"imgdark2":"../pages/play-pause.png" ,"imglight2":"../pages/play-pause_light.png"},{"keypress1":"rewind","imgdark1":"../pages/r-rewind.png","imglight1":"../pages/r-rewind_light.png","keypress2":"fastforward" ,"imgdark2":"../pages/f-forward.png","imglight2":"../pages/f-forward_light.png"}]
    }
    CoverCurrentMedia
    {
        id:coverCurrentMedia
        anchors.top:parent.top 
        width:parent.width
        anchors.bottom: coverActionArea.top
    }
    
    CoverActionList 
    {
        id: remoteActions
        enabled: !coverCurrentMedia.isStandby && !coverCurrentMedia.notFound
        CoverAction 
        {
            id: changeRow
            property int currentRow: 0
            iconSource: isFwdRev ? (Theme.colorScheme == Theme.LightOnDark ? "../pages/play-pause.png": "../pages/play-pause_light.png"): "image://theme/icon-cover-shuffle"
            onTriggered: {
                if(isFwdRev) pressButton("playpause")
                else
                { 
                   currentRow == skySettings.coverRows -1 ? currentRow = 0: currentRow = currentRow + 1
                }                          
            }
        }
        
        CoverAction {
            id: coverButton1

            property string text: coverButtons.value[changeRow.currentRow]["keypress1"] 
    
            iconSource:Theme.colorScheme == Theme.LightOnDark ? coverButtons.value[changeRow.currentRow]["imgdark1"] : coverButtons.value[changeRow.currentRow]["imglight1"] 
            onTriggered: pressButton(text)
        }
        CoverAction {
            id: coverButton2

            property string text: coverButtons.value[changeRow.currentRow]["keypress2"] 
    
            iconSource:Theme.colorScheme == Theme.LightOnDark ? coverButtons.value[changeRow.currentRow]["imgdark2"] : coverButtons.value[changeRow.currentRow]["imglight2"]  
            onTriggered: pressButton(text)
        }
    }
    CoverActionList 
    {          
        id: standbyActions
        enabled: coverCurrentMedia.isStandby && !coverCurrentMedia.notFound
        CoverAction 
        {
            iconSource: "image://theme/graphic-power-off"
            onTriggered: 
            {
                python.call('helper.pressButton',["power"],function() {
                    if(skySettings.autoPressBackCover) pressBack = true
                     coverChannel = !coverChannel
                    })
            }
                
        }
    }
    CoverActionList 
    {          
        id: notFoundActions
        enabled: coverCurrentMedia.notFound
        CoverAction 
        {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: 
            {
                    python.call('helper.findSkyBox',[2],function(result) {
                        if (result)  coverChannel = !coverChannel
                    })
            }
        }
        CoverAction 
        {
            iconSource: "image://theme/icon-cover-dialer"
            onTriggered: 
            {
                pageStack.push("../pages/ConnectSkyBox.qml",{},PageStackAction.Immediate)  
                    app.activate()
            }
        }
    }
    
    function pressButton(buttonText)
    {
        switch(buttonText)
        {
            case ( "fastforward"):
            case("rewind"):
            {
                python.call('helper.pressButton',[buttonText],function() {})
                isFwdRev = true
                return
            }
            case ( "playpause"):
            {
                python.call('helper.pressPlayPause',[isFwdRev],function() {})
                isFwdRev = false
                return
            }
            default:
            {
                python.call('helper.pressButton',[buttonText],function() {})
               coverChannel = !coverChannel
                return
            }
        }
    }
}


