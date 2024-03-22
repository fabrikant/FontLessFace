import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class LCDSymbols extends LCDSevenSegments{

    var symbol_width;
    var dot, colon, degree;

    function initialize(params) {

        LCDSevenSegments.initialize(params);
        self.symbol_width = params[:line_width] + 2 * params[:line_offset];
        initSymbols();
 
    }

    function initSymbols(){

        var dot_poligon = [
            [0, 0],
            [line_width, 0],
            [line_width, line_width],
            [0, line_width]
        ];

        dot = [];
        dot.add(movePoligon(dot_poligon, line_offset, height - line_offset - line_width));

        colon = [];
        colon.add(movePoligon(dot[0], 0, 0));
        colon.add(movePoligon(colon[0], 0, -height / 2));

        degree = [];
        degree.add(movePoligon(dot_poligon, line_offset, 0));

    }

    function writeString(dc, x, y, str, color, border_color, justify){

        var next_x = x;
        var current_y = y;
        var str_width = 0;


        var just = justify;
        if (just >= Graphics.TEXT_JUSTIFY_VCENTER){
            current_y -= height / 2;
            just -= Graphics.TEXT_JUSTIFY_VCENTER;
        }

        if (just > 0){
            for (var i = 0; i < str.length(); i++){
                var sub_str = str.substring(i, i+1);
                if (sub_str.equals(".") || sub_str.equals(":")){
                    str_width += symbol_width;
                }else{
                    str_width += width;
                }
            }
            if (just == Graphics.TEXT_JUSTIFY_CENTER){
                next_x -= str_width / 2;
            }else{
                next_x -= str_width;
            }
        }

        for (var i = 0; i < str.length(); i++){
            var sub_str = str.substring(i, i+1);
            if (sub_str.equals(".")){
                writeSymbol(dc, next_x, current_y, dot, color, border_color);
                next_x += symbol_width;
            }else if (sub_str.equals(":")){
                writeSymbol(dc, next_x, current_y, colon, color, border_color);
                next_x += symbol_width;
            }else if (sub_str.equals("°")){
                writeSymbol(dc, next_x, current_y, degree, color, border_color);
                next_x += symbol_width;    
            }else{
                writeDigit(dc, next_x, current_y, sub_str, color, border_color);
                next_x += width;
            }
        }
    }
    
    function writeSymbol(dc, x, y, symbol_segments, color, border_color){
        dc.setColor(color, color);
        for (var i = 0; i < symbol_segments.size(); i++){
            dc.fillPolygon(movePoligon(symbol_segments[i], x, y));
        } 

        dc.setColor(border_color, border_color);
        for (var i = 0; i < symbol_segments.size(); i++){
            drawSegmentBorder(movePoligon(symbol_segments[i], x, y), dc);
        }
        drawBorder(dc, x, y);
    }
}