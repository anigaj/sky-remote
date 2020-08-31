import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page 
{
    id: page
    property int rowId
    
    ListModel
    {
        id: coverRowsModel
    }
    ConfigurationGroup
    {
        id: skySettings
        path: "/apps/sky-remote"
        property bool autoPressBack: true
        property bool autoPressBackCover: true
        property int coverRows: 3 
    }

    ConfigurationValue
    {
        id: coverButtons
        key: "/apps/sky-remote/coverButtons"
       defaultValue: [{"keypress1":"channeldown","imgdark1":"image://theme/icon-m-down","imglight1":"image://theme/icon-m-down","keypress2":"channelup" ,"imgdark2":"image://theme/icon-m-up" ,"imglight2":"image://theme/icon-m-up"},{"keypress1":"power","imgdark1":"image://theme/graphic-power-off","imglight1":"image://theme/graphic-power-off","keypress2":"playpause" ,"imgdark2":"../pages/play-pause.png" ,"imglight2":"../pages/play-pause_light.png"},{"keypress1":"rewind","imgdark1":"../pages/r-rewind.png","imglight1":"../pages/r-rewind_light.png","keypress2":"fastforward" ,"imgdark2":"../pages/f-forward.png","imglight2":"../pages/f-forward_light.png"}]
        onValueChanged: updateCoverRowsModel()
    }

    SilicaFlickable 
    {
        anchors.fill: parent
        //height:content.height 
        contentHeight: content.height + coverButtonList.height + 2*Theme.paddingLarge 
       
        Column 
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader 
            {
                //% "Settings"
                title: qsTrId("sky-settings")
            }
            
            SectionHeader 
            {
                    //% "Remote Control"
                    text: qsTrId("sky-remote")
            }               
            Label 
            {
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                opacity: 0.6
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                //% "When the Sky Q box is turned on from standby it starts at the home screen and back needs to be pressed to go to the live tv view. This setting allows back to be pressed automatically"
                text: qsTrId("sky-back-para")
            }
            TextSwitch 
            {
                id: backWithStandby
                //% "Automatically press back when coming out of standby mode"
                text: qsTrId("sky-autoback")
                checked: skySettings.autoPressBack
                onClicked: skySettings.autoPressBack = !skySettings.autoPressBack 
            }
            TextSwitch 
            {
                id: backWithStandbyCover
                //% "Automatically press back when coming out of standby mode from cover action"
                text: qsTrId("sky-autoback-cover")
                checked: skySettings.autoPressBackCover
                onClicked: skySettings.autoPressBackCover = !skySettings.autoPressBackCover 
            }
                     
            SectionHeader
            {
                //% "Cover Buttons"
                text: qsTrId("sky-cover-buttons")
            }
                    
            Label 
            {
                anchors 
                {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.paddingLarge
                }
                opacity: 0.6
                wrapMode: Text.Wrap
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                //% "On the cover selected buttons can be cycled through. Configure the rows "
                text: qsTrId("sky-cycle-para")
            }        

            Button 
            {
                width: parent.width - 2* Theme.paddingLarge
               anchors.horizontalCenter: parent.horizontalCenter 
                //% "Add new row"
                text: qsTrId("sky-new-row")
                onClicked: {
                    skySettings.coverRows =skySettings.coverRows + 1
                    var configList = coverButtons.value
                     configList.push({"keypress1":"channeldown","imgdark1":"image://theme/icon-m-down","imglight1":"image://theme/icon-m-down","keypress2":"channelup" ,"imgdark2":"image://theme/icon-m-up","imglight2":"image://theme/icon-m-up"})
                    coverButtons.value = configList 
                } 
            }
        }
            
        SilicaListView 
        {
            id: coverButtonList
            model: coverRowsModel
            width:parent.width 
            anchors.top: content.bottom
            anchors.topMargin: Theme.paddingMedium
            spacing: Theme.paddingSmall
            property real rowHeight
            height:  skySettings.coverRows*rowHeight
            delegate:CoverRow 
            {
                id: cmbBox
                 width: coverButtonList.width
                   
                source1:Theme.colorScheme == Theme.LightOnDark ? model.imgdark1 :model.imglight1  
                source2:Theme.colorScheme == Theme.LightOnDark ?  model.imgdark2 :model.imglight2  
                rowId:model.index 
                
            Component.onCompleted: coverButtonList.rowHeight = height          
                     
            }
        }
        VerticalScrollDecorator {}  
    }
    
    Component.onCompleted: updateCoverRowsModel()
    
    function updateCoverRowsModel()
    { 
        var configList = coverButtons.value
        coverRowsModel.clear()
        for (var i = 0; i< configList.length; ++i) coverRowsModel.append(configList[i])
    }
}
