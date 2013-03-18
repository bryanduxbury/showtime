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


hand_width = 10;
inner_hand_length = 50;
outer_hand_length = 75;

faceplate_thickness = 2 * t; // demo purposes, use same material stacked
faceplate_width = 100;
faceplate_height = 100;


// TODO: these need to be calculated too
inner_shaft_length_below_gear = lock_nut_t + washer_t // out of the back plate
                      + t // the back plate
                      + washer_t + nut_t // back side of the inner shaft gear clamp
                      + washer_t // protrudes from the end of the nut
                      + 0;

inner_shaft_length_above_gear = washer_t + nut_t // front side of the inner shaft gear clamp
                      + washer_t // spacer
                      + t // outer shaft gear
                      + washer_t + lock_nut_t // retainer for outer shaft gear clamp
                      + faceplate_thickness // get through the faceplate
                      + washer_t // placeholder for outer shaft hand face clearance
                      + t // outer shaft hand
                      + 2*t // clearance between the hands
                      + washer_t
                      + 0;
inner_shaft_length = inner_shaft_length_above_gear + inner_shaft_length_below_gear + t;

outer_shaft_above_gear = washer_t + nut_t // clamp nut on the other side of the outer shaft gear
                        + washer_t // clearance on the inside of the faceplate
                        + faceplate_thickness
                        + washer_t // clearance on the outside of the faceplate
                        + 0;

outer_shaft_below_gear = washer_t + nut_t // protrudes from the bottom of the outer shaft gear
                        + washer_t // protrudes from the end of the nut and washer
                        + 0;

outer_shaft_length = outer_shaft_below_gear
                      + t // outer shaft gear
                      + outer_shaft_above_gear
                      + 0;

outer_shaft_hole_distance = max(washer_od, nut_od)/2 + 1 + max(washer_od, nut_od)/2;

distance_between_gears = washer_t + nut_t + washer_t * 2 + t;

// gear parameters
mm_per_tooth = 3;
shaft_gear_num_teeth = 36;
drive_gear_num_teeth = 12;

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

module inner_shaft_gear() {
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth=shaft_gear_num_teeth, thickness=t, hole_diameter=shaft_width);
}

module inner_shaft_assembly() {
  translate([0, 0, t/2 + washer_t + nut_t + 3 * washer_t + t + lock_nut_t/2]) _lock_nut();
  translate([0, 0, t/2 + washer_t + nut_t + 2 * washer_t + t + washer_t/2]) _washer();
  translate([0, 0, t/2 + washer_t + nut_t + washer_t + washer_t/2]) _washer();
  translate([0, 0, t/2 + washer_t + nut_t + washer_t/2]) _washer();
  translate([0, 0, t/2 + washer_t + nut_t/2]) _nut();
  translate([0, 0, t/2 + washer_t/2]) _washer();

  inner_shaft_gear();

  translate([0, 0, -t/2 - washer_t/2]) _washer();
  translate([0, 0, -t/2 - washer_t - nut_t/2]) _nut();
  
  translate([0, 0, -t/2 - washer_t - nut_t - washer_t/2]) _washer();
  translate([0, 0, -t/2 - washer_t - nut_t - washer_t - t - washer_t/2]) _washer();
  translate([0, 0, -t/2 - washer_t - nut_t - washer_t - t - washer_t - lock_nut_t/2]) _lock_nut();
  
  translate([0, 0, inner_shaft_length/2 - t/2 - inner_shaft_length_below_gear]) 
    color([255/255, 120/255, 120/255]) cylinder(r=shaft_width/2, h=inner_shaft_length, center=true, $fn=36);
}

module outer_shaft_gear() {
  difference() {
    gear(mm_per_tooth=mm_per_tooth, number_of_teeth=shaft_gear_num_teeth, thickness=t, hole_diameter=shaft_width);
    for (a=[0:1]) rotate([0, 0, a*180]) translate([outer_shaft_hole_distance, 0, 0]) {
      cylinder(r=shaft_width/2, h=t*2, center=true, $fn=36);
    }
  }
}

module outer_shaft_assembly() {
  for (a=[0]) rotate([0, 0, a*180]) translate([outer_shaft_hole_distance, 0, 0]) {
    translate([0, 0, outer_shaft_length/2 - outer_shaft_below_gear - t/2]) 
      color([255/255, 120/255, 120/255]) cylinder(r=shaft_width/2, h=outer_shaft_length, center=true, $fn=36);

    translate([0, 0, t/2 + washer_t + nut_t/2]) _nut();
    translate([0, 0, t/2 + washer_t/2]) _washer();

    // gear

    translate([0, 0, -(t/2 + washer_t/2)]) _washer();
    translate([0, 0, -(t/2 + washer_t + nut_t/2)]) _nut();
  }

  outer_shaft_gear();

  // translate([0, 0, outer_shaft_length/2 - t/2 - washer_t - nut_t - washer_t]) for (a=[0:1]) rotate([0, 0, a*180]) 
  //   translate([2*shaft_width, 0, 0]) 
}

module retaining_plate() {

}

module inner_hand() {
  color([0/255, 0/255, 0/255])
  union() {
    translate([0, inner_hand_length/2, 0]) cube(size=[hand_width, inner_hand_length, t], center=true);
    translate([0, -nut_od/4 - 1, 0]) cube(size=[hand_width, nut_od/2+2, t], center=true);
  }
}

module inner_hand_nut_cavity() {
  color([32/255, 32/255, 32/255])
  render()
  difference() {
    cube(size=[hand_width, nut_od + 4, t], center=true);
    _hexagon(nut_short_radius - l/2, t * 2);
  }
}

module inner_hand_nut_retainer() {
  color([64/255, 64/255, 64/255])
  difference() {
    cube(size=[hand_width, nut_od + 4, t], center=true);
    cylinder(r=shaft_width/2 + 0.1, h=t*2, center=true, $fn=36);
  }
}

module inner_hand_assembly() {
  translate([0, 0, t]) inner_hand();
  translate([0, 0, 0]) inner_hand_nut_cavity();
  translate([0, 0, -t]) inner_hand_nut_retainer();
}

module outer_hand() {
  color([0/255, 0/255, 0/255])
  render()
  difference() {
    union() {
      translate([0, outer_hand_length/2, 0]) cube(size=[hand_width, outer_hand_length, t], center=true);
      translate([0, -nut_od/4 - 1, 0]) cube(size=[hand_width, nut_od/2+2, t], center=true);
      cylinder(r=outer_radius(mm_per_tooth=mm_per_tooth, number_of_teeth=shaft_gear_num_teeth) + 2, h=t, center=true);
    }
    // translate([0, outer_shaft_hole_distance, 0]) 
    cylinder(r=shaft_width/2+0.5, h=t*2, center=true, $fn=36);
  }
}

module outer_hand_nut_cavity() {
  color([32/255, 32/255, 32/255])
  render()
  difference() {
    union() {
      cube(size=[hand_width, nut_od + 4, t], center=true);
      translate([0, outer_shaft_hole_distance, 0]) cube(size=[hand_width, nut_od+4, t], center=true);
    }
    cylinder(r=shaft_width/2+0.5, h=t*2, center=true, $fn=36);
    translate([0, outer_shaft_hole_distance, 0]) _hexagon(nut_short_radius - l/2, t * 2);
  }
}

module outer_hand_nut_retainer() {
  color([64/255, 64/255, 64/255])
  render()
  difference() {
    union() {
      cube(size=[hand_width, nut_od + 4, t], center=true);
      translate([0, outer_shaft_hole_distance, 0]) cube(size=[hand_width, nut_od+4, t], center=true);
    }
    cylinder(r=shaft_width/2+0.5, h=t*2, center=true, $fn=36);
    translate([0, outer_shaft_hole_distance, 0]) cylinder(r=shaft_width/2+0.5, h=t*2, center=true, $fn=36);
  }
}

module outer_hand_assembly() {
  translate([0, 0, t]) outer_hand();
  translate([0, 0, 0]) outer_hand_nut_cavity();
  translate([0, 0, -t]) outer_hand_nut_retainer();
}

module single_faceplate() {
  difference() {
    cube(size=[faceplate_width, faceplate_height, faceplate_thickness], center=true);
    cylinder(r=outer_radius(mm_per_tooth=mm_per_tooth,number_of_teeth=shaft_gear_num_teeth) + 1, h=2*faceplate_thickness, center=true, $fn=72);
  }
}

motor_shaft_d = 5;
motor_shaft_length = 16;
motor_side_w = 35;
motor_length = 30;
motor_hole_distance = 26;
motor_screw_hole_d = 3;

module mock_motor() {
  color([255/255, 64/255, 64/255])
  difference() {
    union() {
      cube(size=[motor_side_w, motor_side_w, motor_length], center=true);
      translate([0, 0, motor_length/2 + motor_shaft_length/2]) cylinder(r=motor_shaft_d/2, h=motor_length, center=true, $fn=36);
    }
    
    for (i=[0:3]) {
      rotate([0, 0, 90*i]) translate([motor_hole_distance/2, motor_hole_distance/2, motor_length/2]) cylinder(r=motor_screw_hole_d/2, h=10, center=true, $fn=36);
    }
  }
}

module drive_gear() {
  gear(mm_per_tooth=mm_per_tooth,number_of_teeth=drive_gear_num_teeth,hole_d=motor_shaft_d);
}

module assembled() {
  inner_shaft_assembly();
  translate([0, 0, inner_shaft_length_above_gear + t/2 - nut_t]) {
    _nut();
    inner_hand_assembly();
  }

  rotate([0, 0, 90]) translate([0, 0, distance_between_gears]) outer_shaft_assembly();
  translate([0, 0, t/2 + washer_t + nut_t + 2*washer_t + t/2 + outer_shaft_above_gear]) {
    outer_hand_assembly();
  }
  
  translate([0, 0, distance_between_gears + outer_shaft_above_gear - t]) single_faceplate();
  
  translate([0, 0, -t/2 -washer_t - nut_t - washer_t - t]) for (x=[-1,1]) {
    translate([x * center_distance(num_teeth1=shaft_gear_num_teeth, num_teeth2=drive_gear_num_teeth, mm_per_tooth=mm_per_tooth), 0, -motor_length / 2]) mock_motor();
  }
  
  
  // for (y=[0:1]) for (a=[0:3]) {
  //   rotate([0, 0, a*90]) translate([center_distance(mm_per_tooth, pinning_gear_num_teeth, shaft_gear_num_teeth), 0, y * t * 2 ]) pinning_gear();
  // }
  
}

module panelized() {

}

assembled();

// !mock_motor();
!drive_gear();