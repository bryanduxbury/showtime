t = 3; // 1/8" acrylic
l = 0.005 * 25.4; // epilog at techshop

hand_width = 10;
hour_hand_length = 75;
minute_hand_length = 50;

inner_shaft_width = 8;
// TODO: this needs some trig
// outer_shaft_width = 

faceplate_thickness = 12; // half inch mdf???

// TODO: these need to be calculated too
inner_shaft_length = 50;
outer_shaft_length = 45;

// gear parameters
mm_per_tooth = 3;
shaft_gear_num_teeth = 36;
pinning_gear_num_teeth = 12;

module inner_shaft_plate() {
  cube(size=[inner_shaft_width, inner_shaft_length, t], center=true);
}

module inner_shaft_gear() {

}

module inner_shaft_assembly() {
  inner_shaft_gear();
  translate([0, 0, inner_shaft_length/2 - t/2]) for (i=[0:3]) {
    rotate([0, 0, i * 90]) translate([inner_shaft_width / 2 - t/2, 0, 0]) rotate([90, 0, 90]) inner_shaft_plate();
  }
}

module outer_shaft_plate() {

}

module outer_shaft_gear() {

}

module outer_shaft_assembly() {

}

module retaining_plate() {

}

module hour_hand() {
  
}

module minute_hand() {

}

module assembled() {
  inner_shaft_assembly();
}

module panelized() {

}

assembled();