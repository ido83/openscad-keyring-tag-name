// ==========================================
//   Parametric Name Keyring - Ultimate Control
// ==========================================

/* [Design Style] */
// Shape of the tag
tag_shape = "Contour"; // [Contour, Rectangular_Label]

// Style of the text placement (Pop-out = Raised, Carved = Engraved)
text_placement = "Symmetric_Pop_Out"; // [Top_Pop_Out, Symmetric_Pop_Out, Top_Carved, Symmetric_Carved]

// Add a raised border/rim around the edge?
rim_enabled = true; 

/* [Rectangular Label Settings] */
// Manual length of the tag (Only used if shape is Rectangular_Label)
label_width = 60; // [20:1:150]

// Height of the tag (Only used if shape is Rectangular_Label)
label_height = 20; // [10:1:50]

// Corner rounding for the rectangle
label_corner_radius = 3; // [1:0.5:10]

/* [Colors] */
// Color of the base plate
base_color = "Gold"; // [DeepSkyBlue, Red, Green, Yellow, White, Black, Gray, Pink, Purple, Gold, MediumBlue]

// Color of the text (Only affects pop-out mode)
text_color = "MediumBlue"; // [DeepSkyBlue, Red, Green, Yellow, White, Black, Gray, Pink, Purple, Gold, MediumBlue]

/* [Text Settings] */
// The name to display
text_string = "עידו";

// Size of the font
font_size = 12; // [5:1:30]

// Font name (Hebrew: "Arial", "Courier New", "David")
font_name = "Arial:style=Bold";

// Squeeze letters (Creates overlap for single-piece printing)
letter_spacing = 1.0; // [0.4:0.05:1.5]

// Text Direction (ltr for English, rtl for Hebrew)
direction = "rtl"; // [ltr, rtl]

// Extra thickness added to letters (makes them bold)
boldness = 0.2; // [0:0.05:1.0]

/* [Base Dimensions] */
// Padding around text (Only for Contour mode)
base_padding = 2.5; // [1:0.5:10]

// Thickness of the background base plate
base_height = 2.0; // [1:0.5:10]

// Height of the rim (border) relative to the base
rim_height = 1.0; // [0.5:0.5:5]

// Carve mode: Thickness of the layer left in the middle 
center_web_thickness = 0.8; 

/* [Keyring Loop] */
ring_style = "Hole_in_Tab"; // [Hole_in_Tab, 3D_Printed_Loop]

// Slide the ring Left/Right (Rectangular mode: 0 = centered, -30 = left edge, 30 = right edge)
ring_manual_offset = -20; // [-80:1:80]

// Vertical position of the ring
ring_vertical_position = "Middle"; // [Middle, Top, Bottom]

// Roundness/width of the neck connection to the body
ring_roundness = 3; // [1:0.5:10]

// Diameter of the hole/ring inner diameter
hole_diameter = 5; 

// Outer diameter of the 3D printed ring (Only used if ring_style is 3D_Printed_Loop)
loop_outer_diameter = 15; // [10:1:30]

// Thickness of the 3D printed ring (Only used if ring_style is 3D_Printed_Loop)
loop_thickness = 3; // [1:0.5:10]

/* [3D Print Settings] */
// Total thickness of the letters (Must be > base_height to pop out)
text_height = 4.5;

// Smoothness of curves
$fn = 64; 

module keyring() {
    
    // --- UTILITY FUNCTIONS ---
    function is_pop_out() = (text_placement == "Top_Pop_Out" || text_placement == "Symmetric_Pop_Out");
    function is_symmetric() = (text_placement == "Symmetric_Pop_Out" || text_placement == "Symmetric_Carved");
    function is_hole_in_tab() = (ring_style == "Hole_in_Tab");
    
    // Calculate vertical offset for ring tab based on selection
    ring_y_calc = (ring_vertical_position == "Top") ? (label_height/2 - 2) : 
                  (ring_vertical_position == "Bottom") ? -(label_height/2 - 2) : 0;
    
    // --- 1. Text Geometry ---
    module text_shape_2d() {
        offset(r = boldness) {
            text(
                text = text_string, 
                size = font_size, 
                font = font_name, 
                spacing = letter_spacing, 
                direction = direction,
                valign = "center",
                halign = "center" 
            );
        }
    }

    // --- 2. Base Body Logic (The Tag itself) ---
    module body_shape_2d() {
        if (tag_shape == "Rectangular_Label") {
            // -- BOX SHAPE --
            offset(r = label_corner_radius) {
                square([label_width - (label_corner_radius*2), label_height - (label_corner_radius*2)], center = true);
            }
        } else {
            // -- CONTOUR SHAPE --
            offset(r = base_padding) {
                // Fill holes logic (Close internal gaps like inside 'O')
                offset(r = -10) {
                    offset(r = 10) {
                        text_shape_2d();
                    }
                }
            }
        }
    }

    // --- 3. Ring Attachment Footprint (Solid part of the connection) ---
    module ring_attachment_footprint_2d() {
        // We use ring_manual_offset for the X position
        translate([ring_manual_offset, ring_y_calc, 0])
        if (is_hole_in_tab()) {
             // Solid part of the tab for the hole style
             circle(r = (hole_diameter/2) + 2.5);
        } else {
             // For 3D Loop, we need a connection point, which is half the loop thickness wider than the loop inner hole
             circle(r = (hole_diameter/2) + (loop_thickness/2) + 0.5); // Ensure connection
        }
    }
    
    // --- 4. COMPLETE BASE (Body + Neck + Ring) ---
    // Use hull() to create a smooth "neck" connecting the ring connection point to the body.
    module full_base_footprint() {
        union() {
            body_shape_2d(); // The main tag
            
            // The Smart Neck:
            hull() {
                // Anchor at center of tag
                circle(r=ring_roundness); 
                
                // Anchor at ring position
                ring_attachment_footprint_2d();
            }
        }
    }
    
    // --- 5. Rim Geometry (Border) ---
    module rim_shape_2d() {
        difference() {
            full_base_footprint();
            offset(r = -1.5) { // 1.5mm thick rim
                full_base_footprint();
            }
        }
    }
    
    // --- 6. Hole Geometry (For subtraction only) ---
    module hole_shape_2d() {
        translate([ring_manual_offset, ring_y_calc, 0])
        circle(r = hole_diameter / 2);
    }
    
    // --- 7. 3D Printed Loop Geometry (Additive) ---
    module loop_3d_geometry() {
        if (!is_hole_in_tab()) {
            color(base_color)
            difference() {
                // Outer Torus/Ring
                linear_extrude(height = loop_thickness, center = true) {
                    translate([ring_manual_offset, ring_y_calc, 0])
                    circle(r = loop_outer_diameter / 2);
                }
                // Inner Hole
                linear_extrude(height = loop_thickness * 2, center = true) {
                    translate([ring_manual_offset, ring_y_calc, 0])
                    circle(r = hole_diameter / 2);
                }
            }
        }
    }

    // ================= ASSEMBLY =================
    
    difference() {
        union() {
            // A. Base Plate (Center)
            color(base_color)
            linear_extrude(height = base_height, center = true) {
                full_base_footprint();
            }
            
            // B. The Rim (Raised Border)
            if (rim_enabled) {
                color(base_color)
                
                // Base Extrusion for the Rim (Always centered)
                linear_extrude(height = rim_height, center = true) {
                    rim_shape_2d();
                }

                if (!is_symmetric()) {
                    // Shift the rim to the top surface only if not symmetric
                    translate([0,0, base_height/2 + rim_height/2]) 
                    linear_extrude(height = rim_height, center = true) {
                        rim_shape_2d();
                    }
                }
            }
            
            // C. Text Feature (Pop Out or Carve)
            color(is_pop_out() ? text_color : base_color)
            if (is_pop_out()) {
                // POP OUT LOGIC (Additive)
                
                if (is_symmetric()) {
                    // Symmetric Pop Out (Extends top and bottom)
                    linear_extrude(height = text_height, center = true) {
                        text_shape_2d();
                    }
                } else {
                    // Top Pop Out (Extends from the base top surface)
                    translate([0,0, base_height/2]) 
                    linear_extrude(height = text_height, center = false) {
                        text_shape_2d();
                    }
                }
            }
            
            // D. The 3D Loop (New addition - only if selected)
            loop_3d_geometry(); 

        } // End Union (Additive parts)

        // E. Carved Text Logic (Subtractive)
        if (!is_pop_out()) { // If the style is carved
            
            // Carving height to ensure it cuts deeply
            carve_depth = base_height * 2; 

            // Calculate start Z position based on symmetry
            start_z = is_symmetric() ? center_web_thickness/2 : base_height/2;

            // Carve Top Side
            translate([0, 0, start_z])
            linear_extrude(height = carve_depth, center = false) {
                text_shape_2d();
            }
            
            // Carve Bottom Side (Only if symmetric)
            if (is_symmetric()) {
                mirror([0,0,1])
                translate([0, 0, start_z])
                linear_extrude(height = carve_depth, center = false) {
                    text_shape_2d();
                }
            }
        }
        
        // F. The Hole Subtraction (Only for Hole_in_Tab style)
        if (is_hole_in_tab()) {
            linear_extrude(height = 100, center = true) {
                hole_shape_2d();
            }
        }
    }
}

keyring();