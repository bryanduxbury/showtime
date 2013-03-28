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

hand_gear_num_teeth = 150;
hand_width = 10;
minute_hand_length = opening_radius - 5;
hour_hand_length = minute_hand_length - 10;

faceplate_thickness = 2 * t; // demo purposes, use same material stacked
faceplate_width = 100;
faceplate_height = 100;

// gear parameters
mm_per_tooth = 3;
drive_gear_num_teeth = 36;
retaining_gear_num_teeth = 12;

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


motor_shaft_d = 5;
motor_shaft_length = 22;
motor_side_w = 35.2;
motor_length = 28;
motor_hole_distance = 26.2;
motor_screw_hole_d = 3;
motor_dais_r = 11;
motor_dais_t = 2;
motor_shaft_flattened_length = 10;
motor_shaft_flattened_depth = 0.5;


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
  union() {
    gear(mm_per_tooth=mm_per_tooth,number_of_teeth=drive_gear_num_teeth,hole_diameter=motor_shaft_d, thickness=t);
    translate([0, motor_shaft_d/2, 0]) cube(size=[motor_shaft_d*2, motor_shaft_flattened_depth*2, t], center=true);
  }
}

module outer_retainer() {
  render()
  difference() {
    cube(size=[opening_radius*2+20, opening_radius*2+20, t], center=true);
    cube(size=[opening_radius*2, opening_radius*2, t*2], center=true);
  }
}

module hand_gear() {
  color([64/255, 64/255, 255/255, 0.5])
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


module middle_retainer() {
  render()
  difference() {
    cube(size=[opening_radius*2+20, opening_radius*2+20, t], center=true);
    cube(size=[opening_radius*2, opening_radius*2, t*2], center=true);
  }
}

module inner_retainer() {
  render()
  union() {
    cube(size=[opening_radius*2+20, opening_radius*2+20, t], center=true);
    for (i=[0:1]) rotate([0, 0, 180*i]) {
      rotate([0, 0, 25]) 
      translate([-center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth), 0, 0]) union() {
        cylinder(r=motor_side_w/2*sqrt(2)+2.5, h=t, center=true, $fn=72);
        rotate([0, 0, 25]) translate([opening_radius, 0, 0]) cube(size=[opening_radius*2, 2*(motor_side_w/2*sqrt(2)+2.5), t], center=true);
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
  translate([0, 0, -t * 3 - washer_t*3]) {
    minute_hand_assembly();
    for (a=[0:3]) {
      rotate([0, 0, 45+90*a]) 
        translate([center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=retaining_gear_num_teeth), 0, 0]) 
        retaining_gear();
    }

    rotate([0, 0, 25]) 
    translate([center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth), 0, 0]) 
      // rotate([0, 0, 360/drive_gear_num_teeth/2]) 
      drive_gear();
  }
  translate([0, 0, -t * 2 - washer_t*2]) {
    middle_retainer();
  }

  translate([0, 0, -t - washer_t]) {
    hour_hand_assembly();
    for (a=[0:3]) {
      rotate([0, 0, 45+90*a]) 
        translate([center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=retaining_gear_num_teeth), 0, 0]) 
        retaining_gear();
    }

    rotate([0, 0, 25]) 
    translate([-center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth), 0, 0]) {
      // rotate([0, 0, 360/drive_gear_num_teeth/2]) 
      drive_gear();
    }
  }

  translate([0, 0, -motor_shaft_length]) for (i=[0:1]) rotate([0, 0, 180*i]) {
    rotate([0, 0, 25]) 
    translate([-center_distance(mm_per_tooth=mm_per_tooth, num_teeth1=hand_gear_num_teeth, num_teeth2=drive_gear_num_teeth), 0, 0]) {
      mock_motor();
    }
  }

  outer_retainer();
}

module panelized() {

}

assembled();

// !mock_motor();
// !drive_gear();