import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class LCDSevenSegments {

    var height, width, line_width, line_offset;
    var simple_style;
    var segments;

    function initialize(params) {
        
        self.height = params[:height];
        self.width = params[:width];
        self.line_width = params[:line_width];
        self.line_offset = params[:line_offset];
        simple_style = false;
        if (params.hasKey(:simple_style)){
            simple_style = params[:simple_style];
        }

        initPoligons();

    }

    function initPoligons(){
        segments = [];

        if (simple_style){
            
            var horizontal_size = width - 2 * line_offset;
            var vertical_size = Math.round((height - 2 * line_offset) / 2);

            var poligon_horizontal = [
                [0,0],
                [horizontal_size,0], 
                [horizontal_size,line_width],
                [0, line_width]
            ];

            var poligon_vertical = [
                [0, 0],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size]
            ];
         
            var x_right = width - line_width - line_offset;
            var y_vertical = line_offset + vertical_size;
   
            segments.add(movePoligon(poligon_horizontal, line_offset, line_offset));
            segments.add(movePoligon(poligon_vertical, x_right, line_offset));
            segments.add(movePoligon(poligon_vertical, x_right, y_vertical));
            segments.add(movePoligon(poligon_horizontal, line_offset, height - line_offset - line_width));
            segments.add(movePoligon(poligon_vertical, line_offset, y_vertical));
            segments.add(movePoligon(poligon_vertical, line_offset, line_offset));
            segments.add(movePoligon(poligon_horizontal, line_offset, (height - line_width)/ 2));
        
        }else{

            var horizontal_size = width - 2 * line_offset - 5;
            var vertical_size = Math.round((height - 2 * line_offset) / 2) - 2;

            var poligon_up = [
                [0,0],
                [horizontal_size,0],
                [horizontal_size - line_width, line_width],
                [line_width, line_width]
            ];

            var poligon_right_up = [
                [0, line_width],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size - line_width / 2]
            ];

            var poligon_right_bottom = [
                [0, line_width / 2],
                [line_width, 0],
                [line_width, vertical_size],
                [0, vertical_size - line_width]
            ];

            var poligon_left_up = [
                [0,0],
                [line_width, line_width / 2],
                [line_width, vertical_size - line_width],
                [0, vertical_size]
            ];

            var poligon_left_bottom = [
                [0,0],
                [line_width, line_width],
                [line_width, vertical_size - line_width / 2],
                [0, vertical_size]
            ];

            var poligon_bottom = [
                [line_width, 0],
                [horizontal_size - line_width, 0],
                [horizontal_size, line_width],
                [0, line_width]
            ];
            
            var poligon_center = [
                [0,line_width / 2],
                [line_width, 0],
                [horizontal_size - line_width,0],
                [horizontal_size, line_width / 2],
                [horizontal_size - line_width, line_width],
                [line_width, line_width]
            ];
        
            var x_up_bottom = line_offset + 2;
            var x_right = width - line_width - line_offset - 1;
            var y_vertical = line_offset + vertical_size + 2;

            segments.add(movePoligon(poligon_up, x_up_bottom, line_offset));
            segments.add(movePoligon(poligon_right_up, x_right, line_offset));
            segments.add(movePoligon(poligon_right_bottom, x_right, y_vertical));
            segments.add(movePoligon(poligon_bottom, x_up_bottom, height - line_offset - line_width - 2));
            segments.add(movePoligon(poligon_left_up, line_offset, y_vertical));
            segments.add(movePoligon(poligon_left_bottom, line_offset, line_offset));
            segments.add(movePoligon(poligon_center, x_up_bottom, (height - line_width)/ 2-1));
        }

    }

    function movePoligon(poligon, offset_x, offset_y){
        var res = [];
        for (var i = 0; i < poligon.size(); i++){
            res.add([poligon[i][0] + offset_x,  poligon[i][1] + offset_y]);
        }
        return res;
    }

    function writeString(str, dc, x, y, color, border_color){

        for (var i = 0; i < str.length(); i++){
            writeDigit(str.substring(i, i+1), dc, x + i * width, y, color, border_color);
        }
    }

    function writeDigit(dc, x, y, digit, color, border_color){
        
        //           0
        //          5 1
        //           6   
        //          4 2
        //           3

        var digits_dict = {
            "0" =>[0, 1, 2, 3, 4, 5],
            "1" =>[1, 2],
            "2" =>[0, 1, 6, 4, 3],
            "3" =>[0, 1, 6, 2, 3],
            "4" =>[5, 6, 1, 2],
            "5" =>[0, 5, 6, 2, 3],
            "6" =>[0, 5, 4, 3, 2, 6],
            "7" =>[0, 1, 2],
            "8" =>[0, 1, 2, 3, 4, 5, 6],
            "9" =>[0, 1, 2, 3, 5, 6],
            "-" => [6],
        };

        if (digits_dict.hasKey(digit)) {
            var indexes = digits_dict[digit];
            dc.setColor(color, color);
            for (var i = 0; i < indexes.size(); i++){
                dc.fillPolygon(movePoligon(segments[indexes[i]], x, y));
            }
        }
        
        if (simple_style == false){
            dc.setColor(border_color, border_color);
            for (var i = 0; i < segments.size(); i++){
                drawSegmentBorder(movePoligon(segments[i], x, y), dc);
            }
        }
        drawBorder(dc, x, y);
    }

    function drawSegmentBorder(poligon, dc){
        for (var i = 0; i < poligon.size(); i++){
            dc.drawLine(poligon[i][0], poligon[i][1], 
                poligon[(i + 1) % poligon.size()][0], poligon[(i + 1) % poligon.size()][1]);
        }
    }

    function drawBorder(dc, x, y){
        return;
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_GREEN);
        dc.drawRectangle(x, y, self.width,  self.height);
    }
}