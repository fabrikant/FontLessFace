import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class FontLessFaceView extends WatchUi.WatchFace {
    
    var bigDigital, smallFont, mediumFont;

    function initialize() {
        bigDigital = new FontLessFont({:width => 45, :height => 110, :line_width => 12,
            :line_offset =>3, :simple_style => false, :draw_segment_borders => true});
        smallFont = new FontLessFont({:width => 11, :height => 16, :line_width => 1,
            :line_offset => 2, :simple_style => true});
        mediumFont = new FontLessFont({:width => 18, :height => 32, :line_width => 4,
            :line_offset => 2, :simple_style => false});
        
        WatchFace.initialize();

    }

    function onLayout(dc as Dc) as Void {
        
    }

    function onShow() as Void {
    }

	function momentToString(moment){
		var greg = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
        var hours = greg.hour;
        var hourFormat = "%02d";
        if (!System.getDeviceSettings().is24Hour) {
        	hourFormat = "%d";
            if (hours > 12) {
                hours = hours - 12;
            }
        }
		return Lang.format("$1$:$2$", [hours.format(hourFormat), greg.min.format("%02d")]);
	}

    function onUpdate(dc as Dc) as Void {

        var color = Graphics.COLOR_BLACK;
        var b_color = Graphics.COLOR_WHITE;
        dc.setColor(b_color, b_color);
        dc.clear();

        var color_settings = {
            :color => color,
            :background_color => b_color,
            //:border_color => Graphics.COLOR_DK_GRAY,
            :empty_segments_color => Graphics.COLOR_LT_GRAY,
        };

        bigDigital.writeString(dc, dc.getWidth() / 2, dc.getHeight() / 2, momentToString(Time.now()),  
            color_settings, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        smallFont.writeString(dc, dc.getWidth() / 2, dc.getHeight()*75/100, "-2:3.4C°F°",  
            color_settings, Graphics.TEXT_JUSTIFY_CENTER);

        mediumFont.writeString(dc, dc.getWidth() / 2, dc.getHeight()*75/100+20, "-23°C",  
            color_settings, Graphics.TEXT_JUSTIFY_CENTER);    
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

  
}
