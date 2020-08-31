import QtQuick 2.2
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

ContextMenu 
{ 
    property real buttonHeight: downIcon.height 
    MenuItem 
    {
        id: downIcon
        property string iconSrcDark: "image://theme/icon-m-down"   
        property string iconSrcLight: "image://theme/icon-m-down"
        property string keyPress: "channeldown"
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-up"   
        property string iconSrcLight: "image://theme/icon-m-up"
        property string keyPress: "channelup"      
        height: downIcon.height  
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight   
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/graphic-power-off"
        property string iconSrcLight: "image://theme/graphic-power-off"
        property string keyPress: "power"     
        height: downIcon.height 
         Image
        {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit 
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        } 
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-call-recording-on-light"
        property string iconSrcLight: "image://theme/icon-m-call-recording-on-dark"    
        property string keyPress: "record"
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    } 
    MenuItem 
    {
        property string iconSrcDark: "../pages/r-rewind.png"  
        property string iconSrcLight: "../pages/r-rewind_light.png"  
        property string keyPress: "rewind"   
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    } 
    MenuItem 
    {
        property string iconSrcDark: "../pages/play-pause.png"  
        property string iconSrcLight: "../pages/play-pause_light.png"
        property string keyPress: "playpause"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "../pages/f-forward.png"  
        property string iconSrcLight: "../pages/f-forward_light.png"  
        property string keyPress: "fastforward"     
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-back"   
        property string iconSrcLight: "image://theme/icon-m-back"
        property string keyPress: "backup"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight     
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-home"   
        property string iconSrcLight: "image://theme/icon-m-home"
        property string keyPress: "home"    
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight    
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "../pages/sky-icon.png"
        property string iconSrcLight: "../pages/sky-icon_light.png"
        property string keyPress: "sky"    
        height: downIcon.height
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }            
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-lock-more"   
        property string iconSrcLight: "image://theme/icon-lock-more"
        property string keyPress: "sidebar"      
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "../pages/q-icon.png"
        property string iconSrcLight: "../pages/q-icon_light.png"
        property string keyPress: "help"      
        height: downIcon.height    
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }    
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-search"   
        property string iconSrcLight: "image://theme/icon-m-search" 
        property string keyPress: "search"    
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight  
        }
    }
    MenuItem 
    {
        property string iconSrcDark: "image://theme/icon-m-about"   
        property string iconSrcLight: "image://theme/icon-m-about"  
        property string keyPress: "i"   
        height: downIcon.height         
        Image
        {                     
            anchors.centerIn: parent
            source:Theme.colorScheme == Theme.LightOnDark ?  parent.iconSrcDark : parent.iconSrcLight 
        }
    }
}
