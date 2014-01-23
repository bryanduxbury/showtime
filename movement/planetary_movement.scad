use <../publicDomainGearV1.1.scad>

t = 3; // 1/8" acrylic
l = 0.005 * 25.4; // epilog at techshop

shaft_width = 3;
nut_short_radius = 2;
nut_od = nut_short_radius / cos(60) * 2;
nut_t = 2;

lock_nut_t = 4;

washer_id = 3;
washer_od = 8;
washer_t = 1;

opening_radius = 2 * 25.4;
frame_border_w = 10;

hand_gear_num_teeth = 150;
hand_width = 8;
minute_hand_length = opening_radius - 5;
hour_hand_length = minute_hand_length - 10;

faceplate_thickness = 2 * t; // demo purposes, use same material stacked
faceplate_width = 100;
faceplate_height = 100;

// gear parameters
mm_per_tooth = 3;
drive_gear_num_teeth = 32;
retaining_gear_num_teeth = 12;

function frame_w() = opening_radius*2 + frame_border_w*2;
function drive_gear_distance() = center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth);
function motor_covering_radius() = motor_hole_distance/2 * sqrt(2) + 3;
function motor_rotation_angle() = 90-asin((frame_w()/2+motor_covering_radius()) / drive_gear_distance());

module _hexagon(sr,thickness) {
  union() for (a=[0:2]) {
    rotate([0, 0, 60*a]) cube(size=[sr * tan(60) * 2, sr*2, thickness], center=true);
  }
}

module _nut() {
  color([240/255, 240/255, 240/255])
  render() 
  difference() {
    _hexagon(nut_short_radius, nut_t);
    cylinder(r=shaft_width/2, h=nut_t*2, center=true, $fn=36);
  }
}

module _lock_nut() {
  color([200/255, 200/255, 200/255])
  render()
  difference() {
    union() for (a=[0:2]) {
      rotate([0, 0, 60*a]) cube(size=[nut_short_radius * tan(60) * 2, nut_short_radius*2, lock_nut_t], center=true);
    }
    cylinder(r=shaft_width/2, h=lock_nut_t*2, center=true, $fn=36);
  }
}


module _washer() {
  color([240/255, 240/255, 240/255])
  render()
  difference() {
    cylinder(r=washer_od/2, h=washer_t, center=true, $fn=36);
    cylinder(r=washer_id/2, h=washer_t*2, center=true, $fn=36);
  }
}

module _screw(shaft_len=3, shaft_diameter=3, head_thickness=2, head_diameter=4) {
  color([128/255, 128/255, 128/255])
  render()
  union() {
    translate([0, 0, head_thickness/2]) cylinder(r=head_diameter/2, h=head_thickness, center=true, $fn=36);
    translate([0, 0, -shaft_len/2]) cylinder(r=shaft_diameter/2, h=shaft_len, center=true, $fn=36);
  }
}


motor_shaft_d = 5;
motor_shaft_length = 22;
motor_side_w = 35.2;
motor_length = 28;
motor_hole_distance = 26.2;
motor_screw_hole_d = 3;
motor_screw_head_d = 4;
motor_screw_head_t = 2;
motor_dais_r = 11;
motor_dais_t = 2;
motor_shaft_flattened_length = 10;
motor_shaft_flattened_depth = 0.5;


module _motor_mounting_screw(len) {
  _screw(shaft_len=len, shaft_diameter=motor_screw_hole_d, head_thickness=motor_screw_head_t, head_diameter=motor_screw_head_d);
}

module mock_motor() {
  color([192/255, 192/255, 192/255])
  render()
  translate([0, 0, motor_shaft_length/2]) 
  difference() {
    cylinder(r=motor_shaft_d/2, h=motor_shaft_length, center=true, $fn=36);
    translate([0, motor_shaft_d/2, motor_shaft_length/2 - motor_shaft_flattened_length/2]) 
      cube(size=[motor_shaft_d, motor_shaft_flattened_depth*2, motor_shaft_flattened_length], center=true);
  }

  color([255/255, 64/255, 64/255])
  translate([0, 0, -motor_length/2 - motor_dais_t]) difference() {
    union() {
      translate([0, 0, motor_length/2 + motor_dais_t/2]) cylinder(r=motor_dais_r, h=motor_dais_t, center=true);
      cube(size=[motor_side_w, motor_side_w, motor_length], center=true);
    }

    for (i=[0:3]) {
      rotate([0, 0, 90*i]) 
      translate([motor_hole_distance/2, motor_hole_distance/2, motor_length/2]) 
      cylinder(r=motor_screw_hole_d/2, h=10, center=true, $fn=36);
    }
  }
}

module drive_gear() {
  color([128/255, 255/255, 128/255])
  union() {
    gear(mm_per_tooth=mm_per_tooth,number_of_teeth=drive_gear_num_teeth,hole_diameter=motor_shaft_d, thickness=t);
    translate([0, motor_shaft_d/2, 0]) cube(size=[motor_shaft_d*2, motor_shaft_flattened_depth*2, t], center=true);
  }
}

module outer_retainer() {
  render()
  difference() {
    retainer_base();
    cube(size=[opening_radius*2, opening_radius*2, t*2], center=true);    
  }
}

module hand_gear() {
  color([240/255, 240/255, 240/255, 0.25])
  render() 
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth=hand_gear_num_teeth, hole_diameter=0.1, thickness=t);
}

module hour_hand() {
  color([0/255, 0/255, 0/255])
  translate([0, hour_hand_length/2, 0]) 
    cube(size=[hand_width, hour_hand_length, t], center=true);
}

module hour_hand_assembly() {
  hand_gear();
  translate([0, 0, t]) hour_hand();
}

module minute_hand() {
  color([0/255, 0/255, 0/255])
  translate([0, minute_hand_length/2, 0]) 
    cube(size=[hand_width, minute_hand_length, t], center=true);
}

module minute_hand_assembly() {
  hand_gear();
  translate([0, 0, t]) minute_hand();
}

module retainer_base() {
  union() {
    cube(size=[frame_w(), frame_w(), t], center=true);
    for (i=[0:1]) rotate([0, 0, 180*i]) {
      rotate([0, 0, motor_rotation_angle()])
      translate([-drive_gear_distance(), 0, 0])
      difference() {
        union() {
          cylinder(r=motor_covering_radius(), h=t, center=true, $fn=72);
          rotate([0, 0, -motor_rotation_angle()]) 
            translate([opening_radius, 0, 0]) 
              cube(size=[opening_radius*2, 2*(motor_covering_radius()), t], center=true);
        }

        cylinder(r=motor_shaft_d/2+1, h=t*2, center=true, $fn=36);
      }
    }
  }
}


module middle_retainer() {
  render()
  retainer_base();
}

module inner_retainer() {
  render()
  difference() {
    retainer_base();
    for (i=[0:1]) rotate([0, 0, 180*i]) {
      rotate([0, 0, motor_rotation_angle()]) 
      translate([-drive_gear_distance(), 0, 0]) {
        for (a=[0:3]) {
          rotate([0, 0, 90*a]) 
            translate([motor_hole_distance/2, motor_hole_distance/2, 0]) 
              cylinder(r=motor_screw_hole_d/2, h=t*2, center=true, $fn=36);
        }
      }
    }
  }
}

module retaining_gear() {
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth = retaining_gear_num_teeth, thickness=t, hole_diameter=shaft_width);
}

module assembled() {
  translate([0, 0, -t * 4 - washer_t*4]) {
    inner_retainer();
  }

  translate([0, 0, -t * 4 - washer_t*4 + t/2]) {
    for (i=[0:1]) rotate([0, 0, 180*i]) {
      rotate([0, 0, motor_rotation_angle()]) 
      translate([-drive_gear_distance(), 0, 0]) {
        for (a=[0:3]) {
          rotate([0, 0, 90*a]) 
            translate([motor_hole_distance/2, motor_hole_distance/2, 0]) 
              _motor_mounting_screw(15);
        }
      }
    }
    
  }
  
  translate([0, 0, -t * 3 - washer_t*3]) {
    minute_hand_assembly();
    for (a=[0:3]) {
      rotate([0, 0, 45+90*a]) 
        translate([center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=retaining_gear_num_teeth), 0, 0]) 
        retaining_gear();
    }

    rotate([0, 0, motor_rotation_angle()]) 
    translate([drive_gear_distance(), 0, 0]) 
      rotate([0, 0, 360/drive_gear_num_teeth/2]) 
      drive_gear();
  }
  translate([0, 0, -t * 2 - washer_t*2]) {
    // middle_retainer();
  }

  translate([0, 0, -t - washer_t]) {
    hour_hand_assembly();
    for (a=[0:3]) {
      rotate([0, 0, 45+90*a]) 
        translate([center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=retaining_gear_num_teeth), 0, 0]) 
        retaining_gear();
    }

    rotate([0, 0, motor_rotation_angle()]) 
    translate([-drive_gear_distance(), 0, 0]) 
      rotate([0, 0, 360/drive_gear_num_teeth/2]) 
      drive_gear();
  }

  translate([0, 0, -motor_shaft_length]) for (i=[0:1]) rotate([0, 0, 180*i]) {
    rotate([0, 0, motor_rotation_angle()]) 
    translate([-center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth), 0, 0]) {
      mock_motor();
    }
  }

  // outer_retainer();
}

module panelized() {

}

assembled();

// !_motor_mounting_screw(3);
// !mock_motor();
// !drive_gear();