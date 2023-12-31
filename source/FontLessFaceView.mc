import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class FontLessFaceView extends WatchUi.WatchFace {
    
    var bigDigital;

    function initialize() {
        bigDigital = new LCDSymbols({:width => 45, :height => 110, :line_width => 12,
            :line_offset =>3});
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

        var color = Graphics.COLOR_WHITE;
        var b_color = Graphics.COLOR_BLACK;
        dc.setColor(b_color, b_color);
        dc.clear();

        bigDigital.writeString(dc, dc.getWidth() / 2, dc.getHeight() / 2, momentToString(Time.now()),  
            color, Graphics.COLOR_DK_GRAY, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
    }

    function onEnterSleep() as Void {
    }

  
}
