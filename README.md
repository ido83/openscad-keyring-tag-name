# 🔑 Parametric Name Keyring Generator (OpenSCAD)

This OpenSCAD script allows you to generate highly customizable 3D-printable name keyrings. It supports various tag shapes, text styles (raised/engraved), and two-color printing setups, making it flexible for any name or aesthetic preference.

The script is designed for **FDM 3D printing** and ensures features are thick enough for reliable printing.

## ✨ Key Features

* **3 Core Tag Styles:** Switch easily between **Rectangular Label**, **Contour**, and **Text Only** designs. 
* **Bi-directional Text Placement:** Choose between **Pop Out** (raised/embossed) or **Carved** (engraved) text.
* **Symmetric Design:** Text can be placed on the **Top Only** or symmetrically on **Both Sides** of the base for a fully reversible keyring.
* **Two-Color Printing:** Separate color parameters for the `base_color` and `text_color` for easy integration with slicer software features (e.g., filament changes).
* **Robust Ring Attachment:** Automatically generates a smooth connection neck (`hull()` logic) between the tag and the keyring hole/loop, ensuring the keyring does not break off.
* **Integrated 3D Loop:** Option to generate a solid, 3D-printable keyring loop instead of just a hole.

## 🛠 Usage Instructions

1.  **Install OpenSCAD:** Download and install the latest version of [OpenSCAD](http://www.openscad.org/).
2.  **Open the File:** Open the `keyring_generator.scad` file in OpenSCAD.
3.  **Customize:** Adjust the parameters in the Customizer panel (usually on the right side).
4.  **Render:** Press **F6** (or click the Render icon) to fully compile the final 3D model.
5.  **Export:** Go to **File > Export > Export as STL...** and save the file for slicing.

## ⚙️ Parameters Guide

All configuration options are located at the top of the `.scad` file and in the OpenSCAD Customizer Panel.

### `[Design Style]`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `tag_shape` | Select | Sets the overall shape: `Rectangular_Label`, `Contour` (follows text outline), or `Text_Only`. |
| `text_placement` | Select | Defines text style and symmetry: `Top_Pop_Out`, `Symmetric_Pop_Out`, `Top_Carved`, `Symmetric_Carved`. |
| `rim_enabled` | Boolean | Adds a raised border (rim) around the tag (best for `Rectangular_Label`). |

### `[Text Settings]`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `text_string` | String | The name or word to display. |
| `font_name` | String | Font name (e.g., "Arial:style=Bold"). |
| `font_size` | Number | Height of the letters in 2D. |
| `boldness` | Number | Adds a 2D offset to the letters, making them visually and physically thicker for printing. |
| `letter_spacing` | Number | Adjusts letter overlap (`< 1.0` reduces spacing, often required for seamless printing). |
| `direction` | Select | Sets text flow: `ltr` (Left-to-Right, default) or `rtl` (Right-to-Left, for languages like Hebrew/Arabic). |

### `[Base Dimensions]`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `base_height` | Number | Thickness of the main background plate. |
| `text_height` | Number | Total height of the text feature. (Must be higher than `base_height` for pop-out effect). |
| `center_web_thickness`| Number | *Carved Mode Only:* Thickness of the minimum base layer left in the middle of the carved text (prevents 'O' and 'A' centers from falling out). |

### `[Keyring Loop]`

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `ring_style` | Select | `Hole_in_Tab` (for metal rings) or `3D_Printed_Loop` (solid plastic loop). |
| `ring_manual_offset` | Slider | Fine-tune the position of the keyring attachment along the X-axis. |
| `ring_vertical_position` | Select | Aligns the hole/loop attachment vertically: `Middle`, `Top`, or `Bottom`. |

## 💡 Examples

### Example 1: Rectangular Label (Two-Tone, Pop Out)

The most robust and classic style, excellent for two-color prints.

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| `tag_shape` | `Rectangular_Label` | Defines the solid rectangle base. |
| `text_placement` | `Symmetric_Pop_Out` | Text is raised on both sides. |
| `rim_enabled` | `true` | Adds the characteristic raised border. |
| `base_height` | `2.0` | 2mm thick base. |
| `text_height` | `4.5` | Text is 4.5mm thick overall (protrudes 1.25mm from each face). |
| `ring_style` | `Hole_in_Tab` | Ready for a standard metal keyring. |
| `direction` | `ltr` | Default English direction. |

### Example 2: Contour (Engraved, Single-Sided)

A more organic look, with the text carved into the top surface.

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| `tag_shape` | `Contour` | Base follows the outline of the name. |
| `text_placement` | `Top_Carved` | Text is engraved only on the top surface. |
| `rim_enabled` | `false` | No outer border. |
| `base_height` | `4.0` | Thicker base for deeper carving. |
| `center_web_thickness`| `2.0` | Ensures the base remains solid under the carved letters. |
| `base_padding` | `3.0` | Creates a small margin around the text outline. |
| `direction` | `ltr` | |

### Example 3: Text Only (Minimalist)

The base and the text are the same shape, offering a minimalist, flowing design.

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| `tag_shape` | `Text_Only` | Uses the text geometry as the entire tag body. |
| `text_placement` | `Top_Pop_Out` | (Ignored, but required for syntax) |
| `rim_enabled` | `false` | No base or border. |
| `base_height` | `2.0` | (Ignored, set to `text_height` internally) |
| `text_height` | `4.0` | Total thickness of the tag. |
| `ring_style` | `3D_Printed_Loop` | A robust, fully integrated loop is generated. |
| `direction` | `ltr` | |

### Example 4: Right-to-Left (RTL) Text

Configuration for languages like Hebrew, ensuring the text flows from right to left using the appropriate font.

| Parameter | Value | Notes |
| :--- | :--- | :--- |
| `tag_shape` | `Rectangular_Label` | Using a label for clear boundaries. |
| `text_placement` | `Top_Pop_Out` | Raised text on one side. |
| `text_string` | `"שלום"` | (Hebrew for "Shalom/Hello") |
| `font_name` | `"David"` | A commonly available Hebrew font. |
| `direction` | `rtl` | **Crucial:** Sets the text flow to Right-to-Left. |
| `ring_manual_offset` | `0` | Center the ring attachment. |
