import QtQuick 2.0
import Sailfish.Silica 1.0

BackgroundItem 
{
    id: remoteButton

    property string text
    property bool highlighted: down
    property alias font: label.font
    property bool isIcon: false
    property alias source:  buttonIcon.source

    onPressed: {
        if (_feedbackEffect) {
            _feedbackEffect.play()
        }
    }

    Image
    {                       
        id: buttonIcon
        visible: isIcon
        anchors.centerIn: parent
    }
    
    Label 
    {
        id: label
        visible:!isIcon
        font 
        {
            family: Theme.fontFamilyHeading
            pixelSize: Theme.fontSizeExtraLarge
        }
        anchors.centerIn: parent
        text: remoteButton.text
        color: highlighted ? Theme.highlightColor : Theme.primaryColor
    }
}
