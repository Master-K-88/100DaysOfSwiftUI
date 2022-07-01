//
//  ColorRes.swift
//  Created by YPY GLOBAL on 1/22/19.
//  Copyright © 2019 YPY GLOBAL. All rights reserved.
//  Color Format Supported : RGB or ARBG same as Android Version
//

class ColorRes{
    
//    let primaryColor = UIColor(red: 1.00, green: 0.89, blue: 0.25, alpha: 1.0);
//    let primaryLightColor = UIColor(red: 1.00, green: 1.00, blue: 0.46, alpha: 1.0);
//    let primaryDarkColor = UIColor(red: 0.78, green: 0.70, blue: 0.00, alpha: 1.0);
//    let primaryTextColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
//    let secondaryColor = UIColor(red: 0.98, green: 0.35, blue: 0.19, alpha: 1.0);
//    let secondaryLightColor = UIColor(red: 1.00, green: 0.55, blue: 0.37, alpha: 1.0);
//    let secondaryDarkColor = UIColor(red: 0.75, green: 0.14, blue: 0.00, alpha: 1.0);
//    let secondaryTextColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);
    
    static let backgroun_color = "Background_color"
    static let cell_bgcolor = "cell_bgcolor"
    static let label_color = "label_color"
    static let textfield_bgcolor = "textfield_bgcolor"
    static let tint_color = "tint_color"
    static let search_textcolor = "search_textcolor"
    
    
    static let audiobook_bgcolor = getColor(hex: "#00BBF9")
    static let headset_bgcolor = getColor(hex: "#F5F5F5")
    static let live_bgcolor = getColor(hex: "#9B5DE5")
    static let short_bgcolor = getColor(hex: "#FEE440")
    static let podcast_bgcolor = getColor(hex: "#00F5D4")
    
    // set color accent for app
    static let color_accent = "#ffae29"
    
    // set color back ground app in "Just Action Bar" mode
    static let color_background = "#121212"
    
    // set pull to refresh indicator color
    static let color_pull_to_refresh = "#ffae29"
    static let color_login = "#008fff"
    static let text_search_hint_color = "#8A000000"
    
    // Basic colors
    static let text_black = "#000000"
    
    //tab indicator color
    static let tab_indicator_color = "#00FFFFFF"
    
    //Tab layout background
    static let tab_bg_color = "#000000"
    
    //tab text color when focusing the tab
    static let tab_text_focus_color = "#ffae29"
    
    //tab text color when normal
    static let tab_text_normal_color = "#7Affffff"

    //<!--list text color when you use the type list ui-->
    static let list_view_color_main_text = "#ffffff"
    
    //<!--list subtext color when you use the type list ui-->
    static let list_view_color_author_text = "#ddffffff"
    
    //<!--list subtext color when you use the type list ui-->
    static let list_view_color_second_text = "#8Affffff"
    
    //dialog background color
    static let dialog_bg_color = "#221f23"
    
    //dialog main text color
    static let dialog_color_main_text = "#ffffff"
    
    //dialog main second text color
    static let dialog_secondary_text = "#8Affffff"
    
    static let dialog_divider_color = "#1fffffff"
    
    //dialog color accent for the accent button ( as button Done in Sleep Mode)
    static let dialog_color_accent = "#ffae29"
 
    //footer load more background color
    static let color_load_more_bg = "#FFFFFF"
    
    //progress color in the home screen
    static let progress_color = "#E91E63"
    
    //progress color in the splash screen
    static let progress_splash_color = "#ffffff"
    
    // set slider volume color
    static let color_volume_slider = "#ffae29"
    
    // set thumb slider volume color
    static let color_volume_thumb_slider = "#ffae29"
    
    //main text color in the player screen
    static let play_color_text = "#ffffff"
 
    //main subtext color in the player screen
    static let play_color_secondary_text = "#ffffff"
    
    static let main_color_divider = "#1fffffff"
    
    //main text color in home screen
    static let main_color_text_color = "#ffffff"
    
    //main secondary text color in homescreen
    static let main_second_text_color = "#8Affffff"
  
    //======IAP COLOR=====================
    static let skip_color = "#c2c2c2"
    static let buy_color = "#fc3a90"
    static let purchase_color = "#1db954"
    static let purchase_second_color = "#8A1db954"
   //======END IAP COLOR=====================
    
    static let toast_bg_color = "#ffae29"
    static let toast_text_color = "#de000000"
    
    //=========CHAT COLOR==========
    static let array_categories_colors = ["#6002ee","#61d800","#3722f6","#cd00ea"
        ,"#ef0078","#f47100","#0097A7","#0091EA",
         "#009688","#795548","#F4511E","#607D8B","#E65100",
         "#00E676","#7e3ff2"]
    
    static let text_chat_color = "#deffffff"
    static let text_second_chat_color = "#8Affffff"
    static let text_hint_chat_color = "#4fffffff"

    static let subscribe_color = "#ec0b65"
    static let subscribed_color = "#00000000"
    static let color_recording = "#ef0078"
    static let card_color_live = "#551947"
    
    static let color_live = "#ef0078"
    static let color_join = "#28a745"
    static let color_host = "#28a745"
    static let card_color_upcoming = "#362222"
    static let color_notify_me = "#fe864d"
    static let card_color_past = "#141414"
    static let color_my_event = "#ffae29"
    static let color_cancel = "#ef0078"
    
    static let state_color_error = "#ffae29"
    static let state_color_in_active = "#cccccc"
    static let state_color_active = "#ffffff"
    
    static let live_bg_avatar_normal = "#4fffffff"
    
    static let snack_bar_bg_color = "#000000"
    static let snack_bar_text_color = "#ffffff"
    static let snack_bar_action_color = "#ffae29"


    
}
