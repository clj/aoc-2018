/* [Parameters] */

// Show solution
Solution=true;

// Connect bots that are in range
ConnectBots=true;

// Show a bots centre
BotCentre=true;

// Show the range of the bots
BotRange=true;

// Type of range to show
BotRangeType="M"; // [M:Manhattan Distance, O:Octahedron]

// Show a bots radius
BotRadius=false;

// Show where bot AABB cubes intersect
BotBoundsIntersection=false;

/* [Enabled bots] */

Bot1=true;
Bot2=true;
Bot3=true;
Bot4=true;
Bot5=true;
Bot6=true;

function manhattan_distance(a, b) = 
    abs(a[0] - b[0]) + abs(a[1] - b[1]) + abs(a[2] - b[2]);
 

module bot_colour(c, r, alpha=0.2) {
    color(rands(0,1,3, seed = c[0] + c[1] + c[2]+ r), alpha = alpha)
        children(); 
}


module bot(c, r) {
    bot_colour(c, r, alpha=1)
        translate(c)
            sphere(0.25, center=true); 
}


module bot_range(c, r) {
    color(rands(0,1,3, seed = c[0] + c[1] + c[2]+ r), alpha = 0.05)
    union()
        for(x = [c[0]-r:c[0]+r])
            for(y = [c[1]-r:c[1]+r])
                for(z = [c[2]-r:c[2]+r])   
                    if(manhattan_distance(c, [x, y, z]) <= r) {
                        translate([x, y, z]) cube(1.001, center=true);
                    }
 }


module bot_octahedron(c, r) {
    coords = [
        c + [r, 0, 0],
        c + [-r, 0, 0],
        c + [0, r, 0],
        c + [0, -r, 0],
        c + [0, 0, r],
        c + [0, 0, -r],
    ];
    faces=[
        [0, 3, 4],
        [0, 2, 4],
        [2, 1, 4],
        [3, 1, 4],
        [0, 3, 5],
        [0, 2, 5],
        [2, 1, 5],
        [3, 1, 5],
    ];
    color(rands(0,1,3, seed = c[0] + c[1] + c[2]+ r), alpha = 0.25)
        polyhedron(coords, faces);
}

module bot_radius(c, r) {
    color(rands(0,1,3, seed = c[0] + c[1] + c[2]+ r), alpha = 0.25)
        union() {
            translate(c) {
                cube([1, 1, r * 2 + 1], center=true);
                rotate([0, 90, 0])
                    cube([1, 1, r * 2 + 1], center=true);
                 rotate([90, 0, 0])
                    cube([1, 1, r * 2 + 1], center=true);
            }
        }
}


module bounds(c, r) {
    color(rands(0,1,3, seed = c[0] + c[1] + c[2]+ r), alpha = 0.6)
    translate(c)
    cube((r+.5001)*2, center=true);
}


/* From: http://forum.openscad.org/Rods-between-3D-points-td13104.html */
// draw ray between 2 specified points 
module draw_ray(p1, p2, tk) { 
  translate((p1+p2)/2) 
    rotate([-acos((p2[2]-p1[2]) / norm(p1-p2)),0, 
            -atan2(p2[0]-p1[0],p2[1]-p1[1])]) 
       cylinder(r1=tk, r2=tk*0.5, h=norm(p1-p2), $fn = 6, center = true); 
} 

if(Solution) {
    color("red", alpha=1)
        translate([12, 12, 12])
            sphere(0.5, center=true, $fs = 0.01); 
}

all_bots = [
    [[10, 12, 12], 2],
    [[12, 14, 12], 2],
    [[16, 12, 12], 4],
    [[14, 14, 14], 6],
    [[50, 50, 50], 200],
    [[10, 10, 10], 5],
];


bots = concat(
    Bot1 ? [all_bots[0]] : [],
    Bot2 ? [all_bots[1]] : [],
    Bot3 ? [all_bots[2]] : [],
    Bot4 ? [all_bots[3]] : [],
    Bot5 ? [all_bots[4]] : [],
    Bot6 ? [all_bots[5]] : []);

if(ConnectBots) {
    for(b1 = bots)
        for(b2 = bots) {
            if(b1 != b2)
                if(manhattan_distance(b1[0], b2[0]) <= max(b1[1], b2[1])) {
                    draw_ray(b1[0], b2[0], 0.1);
                }
            }
 }


if(BotBoundsIntersection)
    intersection_for (coordinates = bots) {
        bounds(coordinates[0], coordinates[1]);
    }
  
for (coordinates = bots) {
    if(BotCentre)
        bot(coordinates[0], coordinates[1]);
    if(BotRadius)
        bot_radius(coordinates[0], coordinates[1]);
    if(BotRange)
        if(BotRangeType == "M") {
            if (coordinates[1] < 10) {
                    bot_range(coordinates[0], coordinates[1]);
            }
        } else {
            bot_octahedron(coordinates[0], coordinates[1]);
        }
}

