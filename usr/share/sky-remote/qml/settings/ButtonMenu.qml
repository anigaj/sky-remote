import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

ContextMenu 
{ 
    property real buttonHeight: downIcon.height 
    MenuItem 
    {
        id: downIcon
        property string iconSrc: "image://theme/icon-m-down"   
        property string keyPress: "channeldown"
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc  
        }
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-up"   
        property string keyPress: "channelup"      
        height: downIcon.height  
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc 
        }
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/graphic-power-off"
        property string keyPress: "power"     
        height: downIcon.height 
         Image
        {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit 
            source : parent.iconSrc
        } 
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-call-recording-on-light"   
        property string keyPress: "record"
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    } 
    MenuItem 
    {
        property string iconSrc: "../pages/r-rewind.png"  
        property string keyPress: "rewind"   
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    } 
    MenuItem 
    {
        property string iconSrc: "../pages/play-pause.png"  
        property string keyPress: "playpause"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    }
    MenuItem 
    {
        property string iconSrc: "../pages/f-forward.png"  
        property string keyPress: "fastforward"     
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-back"   
        property string keyPress: "backup"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc   
        }
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-home"   
        property string keyPress: "home"    
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc  
        }
    }
    MenuItem 
    {
        property string iconSrc: "../pages/sky-icon.png"
        property string keyPress: "sky"    
        height: downIcon.height
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }            
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-lock-more"   
        property string keyPress: "sidebar"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    }
    MenuItem 
    {
        property string iconSrc: "../pages/q-icon.png"
        property string keyPress: "help"      
        height: downIcon.height    
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }    
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-search"   
        property string keyPress: "search"    
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    }
    MenuItem 
    {
        property string iconSrc: "image://theme/icon-m-about"   
        property string keyPress: "i"   
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source: parent.iconSrc
        }
    }
}
