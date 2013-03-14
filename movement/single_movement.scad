use <../publicDomainGearV1.1.scad>

t = 3; // 1/8" acrylic
l = 0.005 * 25.4; // epilog at techshop

shaft_width = 3;
nut_short_radius = 2;
nut_t = 3;

lock_nut_t = 4;

washer_id = 3;
washer_od = 8;
washer_t = 1;


hand_width = 10;
hour_hand_length = 75;
minute_hand_length = 50;

faceplate_thickness = 12; // half inch mdf???

// TODO: these need to be calculated too
inner_shaft_length = lock_nut_t + washer_t // out of the back plate
                      + t // the back plate
                      + washer_t + nut_t // back side of the inner shaft gear clamp
                      + t // inner shaft gear
                      + washer_t + nut_t // front side of the inner shaft gear clamp
                      + washer_t // spacer
                      + t // outer shaft gear
                      + washer_t + lock_nut_t // retainer for outer shaft gear clamp
                      + faceplate_thickness // get through the faceplate
                      + washer_t // placeholder for outer shaft hand face clearance
                      + t // outer shaft hand
                      + washer_t // clearance between the hands
                      + 0;
                      
outer_shaft_length = nut_t // protrudes from the bottom of the outer shaft gear
                      + t // outer shaft gear
                      + nut_t // clamp nut on the other side of the outer shaft gear
                      + washer_t // clearance on the inside of the faceplate
                      + faceplate_thickness
                      + washer_t // clearance on the outside of the faceplate
                      + t // outer shaft hand itself
                      + 0;

outer_shaft_hole_distance = max(washer_od, nut_short_radius * tan(60) * 2)/2 + 2 + max(washer_od, nut_short_radius * tan(60))/2;

// gear parameters
mm_per_tooth = 3;
shaft_gear_num_teeth = 36;
pinning_gear_num_teeth = 12;

module _nut() {
  color([240/255, 240/255, 240/255])
  render() 
  difference() {
    union() for (a=[0:2]) {
      rotate([0, 0, 60*a]) cube(size=[nut_short_radius * tan(60) * 2, nut_short_radius*2, nut_t], center=true);
    }
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
  
  translate([0, 0, inner_shaft_length/2 - t/2 - lock_nut_t - washer_t * 4 - nut_t * 2]) 
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
  for (a=[0:1]) rotate([0, 0, a*180]) translate([outer_shaft_hole_distance, 0, 0]) {
    translate([0, 0, outer_shaft_length/2 - t/2 - washer_t - nut_t - washer_t]) 
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

module pinning_gear() {
  gear(mm_per_tooth=mm_per_tooth, number_of_teeth=pinning_gear_num_teeth, thickness=t, hole_diameter=3);
}

module retaining_plate() {

}

module hour_hand() {
  
}

module minute_hand() {

}

module assembled() {
  inner_shaft_assembly();
  translate([0, 0, t/2 + washer_t + nut_t + 2*washer_t + t/2]) outer_shaft_assembly();
  
  // for (y=[0:1]) for (a=[0:3]) {
  //   rotate([0, 0, a*90]) translate([center_distance(mm_per_tooth, pinning_gear_num_teeth, shaft_gear_num_teeth), 0, y * t * 2 ]) pinning_gear();
  // }
  
}

module panelized() {

}

assembled();