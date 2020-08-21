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
       defaultValue: [{"keypress1":"channeldown","imgsource1":"image://theme/icon-m-down","keypress2":"channelup" ,"imgsource2":"image://theme/icon-m-up"},{"keypress1":"power","imgsource1":"image://theme/graphic-power-off","keypress2":"playpause" ,"imgsource2":"../pages/play-pause.png"},{"keypress1":"rewind","imgsource1":"../pages/r-rewind.png","keypress2":"fastforward" ,"imgsource2":"../pages/f-forward.png"}]
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
        enabled: !coverCurrentMedia.isStandby
        CoverAction 
        {
            id: changeRow
            property int currentRow: 0
            iconSource: isFwdRev ? "../pages/play-pause.png" : "image://theme/icon-cover-shuffle"
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
    
            iconSource:coverButtons.value[changeRow.currentRow]["imgsource1"] 
            onTriggered: pressButton(text)
        }
        CoverAction {
            id: coverButton2

            property string text: coverButtons.value[changeRow.currentRow]["keypress2"] 
    
            iconSource:coverButtons.value[changeRow.currentRow]["imgsource2"] 
            onTriggered: pressButton(text)
        }
    }
    CoverActionList 
    {          
        id: standbyActions
        enabled: coverCurrentMedia.isStandby
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


