use core::time::Duration;

use mlua::prelude::*;

pub type Vec2 = [f32; 2];

macro_rules! config {
    (
        // Config config {
        $config:ident {
            // general: General,
            $( $conf_section:ident: $conf_type:ty, )*
        }

        $(
            // General general {
            $section:ident $section_lower:ident {
                $(
                    @table $property:ident: $tabletype:ty,
                )*

                $(
                    $( #[$meta:meta] )*
                    // gaps_in: impl Into<CssGaps> => CssGaps,
                    //          ^^^^^^^^^^^^^^^^^^------------- argument type for function
                    //                                ^^^^^^^-- type that implements IntoLua
                    //                                          (.into() used for conversion)
                    $option:ident: $pubtype:ty => $innertype:ty,
                )*
            }
        )*
    ) => {
        pub struct Config<'a> {
            lua: &'a Lua,
            $( pub $conf_section: $conf_type, )*
        }

        impl<'a> Config<'a> {
            pub fn new(lua: &'a Lua) -> LuaResult<Self> {
                $( let $conf_section = <$conf_type>::new(lua)?; )*

                Ok(Self {
                    lua,
                    $( $conf_section, )*
                })
            }

            pub fn apply(&self) -> LuaResult<()> {
                let config_table = self.lua.create_table()?;

                $(
                    config_table.set(stringify!($conf_section), self.$conf_section.table.clone())?;
                )*

                self.lua
                    .globals()
                    .get::<LuaTable>("hl")?
                    .get::<LuaFunction>("config")?
                    .call::<()>(config_table)?;

                Ok(())
            }
        }

        $(
            pub struct $section {
                /// Raw Lua table access, be careful.
                pub table: LuaTable,
                $( pub $property: $tabletype, )*
            }

            impl $section {
                pub fn new(lua: &Lua) -> LuaResult<Self> {
                    let table = lua.create_table()?;
                    $(
                        let $property = <$tabletype>::new(lua)?;
                        table.set(stringify!($property), $property.table.clone())?;
                    )*
                    Ok(Self {
                        table,
                        $( $property, )*
                    })
                }

                $(
                    $( #[$meta] )*
                    pub fn $option(&self, value: $pubtype) -> LuaResult<()> {
                        let value: $innertype = value.into();
                        self.table.set(stringify!($option), value)?;
                        Ok(())
                    }
                )*
            }
        )*
    };
}

macro_rules! enums {
    (
        $(
            $( #[$meta:meta] )*
            $name:ident {
                $(
                    $( #[$varmeta:meta] )*
                    $variant:ident = $value:expr,
                )*
            }
        )*
    ) => {
        $(
            $( #[$meta] )*
            #[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
            pub enum $name {
                $(
                    $( #[$varmeta] )*
                    $variant = $value,
                )*
            }

            impl From<$name> for i32 {
                fn from(value: $name) -> Self {
                    match value {
                        $(
                            $name::$variant => $value,
                        )*
                    }
                }
            }
        )*
    };
}

config! {
    Config {
        general: General,
        decoration: Decoration,
        animations: Animations,
        input: Input,
        gestures: Gestures,
        group: Group,
        groupbar: Groupbar,
        misc: Misc,
        layout: Layout,
        binds: Binds,
        xwayland: XWayland,
        opengl: OpenGL,
        render: Render,
        cursor: Cursor,
        ecosystem: Ecosystem,
        quirks: Quirks,
        debug: Debug,
        dwindle: Dwindle,
        master: Master,
        scrolling: Scrolling,
    }

    General general {
        @table snap: GeneralSnap,

        /// The size of the border around windows, in pixels.
        ///
        /// Default: `1`
        border_size: u32 => u32,

        /// The gaps between windows, in pixels.
        ///
        /// Default: `5`
        gaps_in: impl Into<CssGaps> => CssGaps,

        /// The gaps between windows and monitor edges, in pixels.
        ///
        /// Default: `20`
        gaps_out: impl Into<CssGaps> => CssGaps,

        /// Gaps between windows and monitor edges for floating windows. `-1` means default.
        ///
        /// Default: `0`
        float_gaps: impl Into<CssGaps> => CssGaps,

        /// Gaps between workspaces. Stacks with `gaps_out`.
        ///
        /// Default: `0`
        gaps_workspaces: impl Into<CssGaps> => CssGaps,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Border color for inactive windows. Can be a solid color or a gradient.
        ///
        /// Default: `0xff444444`
        col_inactive_border: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Border color for the active window. Can be a solid color or a gradient.
        ///
        /// Default: `0xffffffff`
        col_active_border: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Inactive border color for windows that cannot be added to a group.
        ///
        /// Default: `0xffffaaff`
        col_nogroup_border: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Active border color for windows that cannot be added to a group.
        ///
        /// Default: `0xffff00ff`
        col_nogroup_border_active: impl Into<LuaValue> => LuaValue,

        // TODO: enum: dwindle/master/scrolling/monocle, plus custom `lua:name` layouts.
        /// Which layout to use.
        ///
        /// Default: `"dwindle"`
        layout: impl Into<String> => String,

        /// If true, moving focus in a direction where no window is found will not fall back to the
        /// next available window.
        ///
        /// Default: `false`
        no_focus_fallback: bool => bool,

        /// Enables resizing windows by clicking and dragging on borders and gaps.
        ///
        /// Default: `false`
        resize_on_border: bool => bool,

        /// Extends the border area where windows can be clicked and dragged.
        ///
        /// Only used when `resize_on_border` is enabled.
        ///
        /// Default: `15`
        extend_border_grab_area: u32 => u32,

        /// Shows a cursor icon when hovering over borders.
        ///
        /// Only used when `resize_on_border` is enabled.
        ///
        /// Default: `true`
        hover_icon_on_border: bool => bool,

        /// Master switch for allowing tearing.
        ///
        /// Default: `false`
        allow_tearing: bool => bool,

        // TODO: enum/Option. `0` disables, `1..=4` selects a corner clockwise from top-left.
        /// Forces floating windows to use a specific corner when being resized.
        ///
        /// Default: `0`
        resize_corner: u32 => u32,

        /// Whether parent windows of modals remain interactive.
        ///
        /// Default: `true`
        modal_parent_blocking: bool => bool,

        /// Overrides the system locale, for example `en_US` or `es`.
        ///
        /// Default: `""`
        locale: impl Into<String> => String,
    }

    // TODO: subcategory path is `general.snap`. Macro needs nested category support or path metadata.
    GeneralSnap general_snap {
        /// Enables snapping for floating windows.
        ///
        /// Default: `false`
        enabled: bool => bool,

        /// Minimum gap in pixels between windows before snapping.
        ///
        /// Default: `10`
        window_gap: u32 => u32,

        /// Minimum gap in pixels between window and monitor edges before snapping.
        ///
        /// Default: `10`
        monitor_gap: u32 => u32,

        /// If true, windows snap so that only one border’s worth of space is between them.
        ///
        /// Default: `false`
        border_overlap: bool => bool,

        /// If true, snapping respects `general.gaps_in`.
        ///
        /// Default: `false`
        respect_gaps: bool => bool,
    }

    Decoration decoration {
        /// Rounded corner radius in layout pixels.
        ///
        /// Default: `0`
        rounding: u32 => u32,

        /// Adjusts the curve used for rounded corners.
        ///
        /// `2.0` is a circle, `4.0` is a squircle, and `1.0` is a triangular corner.
        ///
        /// Default: `2.0`
        rounding_power: f64 => f64,

        /// Opacity of active windows.
        ///
        /// Default: `1.0`
        active_opacity: f64 => f64,

        /// Opacity of inactive windows.
        ///
        /// Default: `1.0`
        inactive_opacity: f64 => f64,

        /// Opacity of fullscreen windows.
        ///
        /// Default: `1.0`
        fullscreen_opacity: f64 => f64,

        /// Enables dimming of parents of modal windows.
        ///
        /// Default: `true`
        dim_modal: bool => bool,

        /// Enables dimming of inactive windows.
        ///
        /// Default: `false`
        dim_inactive: bool => bool,

        /// How much inactive windows should be dimmed.
        ///
        /// Default: `0.5`
        dim_strength: f64 => f64,

        /// How much to dim the rest of the screen when a special workspace is open.
        ///
        /// Default: `0.2`
        dim_special: f64 => f64,

        /// How much the `dim_around` window rule should dim by.
        ///
        /// Default: `0.4`
        dim_around: f64 => f64,

        /// Path to a custom shader applied at the end of rendering.
        ///
        /// Default: `""`
        screen_shader: impl Into<String> => String,

        /// Whether the window border should be part of the window.
        ///
        /// Default: `true`
        border_part_of_window: bool => bool,
    }

    // TODO: subcategory path is `decoration.blur`.
    DecorationBlur decoration_blur {
        /// Enables Kawase window background blur.
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Blur size or distance.
        ///
        /// Default: `8`
        size: u32 => u32,

        /// Number of blur passes to perform.
        ///
        /// Default: `1`
        passes: u32 => u32,

        /// Makes the blur layer ignore the opacity of the window.
        ///
        /// Default: `true`
        ignore_opacity: bool => bool,

        /// Enables additional blur optimizations.
        ///
        /// Default: `true`
        new_optimizations: bool => bool,

        /// If enabled, floating windows ignore tiled windows in their blur.
        ///
        /// Only available when `new_optimizations` is true.
        ///
        /// Default: `false`
        xray: bool => bool,

        /// How much noise to apply to blur.
        ///
        /// Default: `0.0117`
        noise: f64 => f64,

        /// Contrast modulation for blur.
        ///
        /// Default: `0.8916`
        contrast: f64 => f64,

        /// Brightness modulation for blur.
        ///
        /// Default: `0.8172`
        brightness: f64 => f64,

        /// Increases saturation of blurred colors.
        ///
        /// Default: `0.1696`
        vibrancy: f64 => f64,

        /// How strongly `vibrancy` affects dark areas.
        ///
        /// Default: `0.0`
        vibrancy_darkness: f64 => f64,

        /// Whether to blur behind the special workspace.
        ///
        /// Default: `false`
        special: bool => bool,

        /// Whether to blur popups, such as right-click menus.
        ///
        /// Default: `false`
        popups: bool => bool,

        /// Alpha threshold below which popup pixels will not blur.
        ///
        /// Default: `0.2`
        popups_ignorealpha: f64 => f64,

        /// Whether to blur input methods, such as fcitx5.
        ///
        /// Default: `false`
        input_methods: bool => bool,

        /// Alpha threshold below which input method pixels will not blur.
        ///
        /// Default: `0.2`
        input_methods_ignorealpha: f64 => f64,
    }

    // TODO: subcategory path is `decoration.shadow`.
    DecorationShadow decoration_shadow {
        /// Enables drop shadows on windows.
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Shadow range or size in layout pixels.
        ///
        /// Default: `4`
        range: u32 => u32,

        /// Power used to render shadow falloff.
        ///
        /// Default: `3`
        render_power: u32 => u32,

        /// Makes shadows sharp, akin to infinite render power.
        ///
        /// Default: `false`
        sharp: bool => bool,

        // TODO: color should probably get a real Rust type instead of raw LuaValue.
        /// Shadow color. Alpha controls shadow opacity.
        ///
        /// Default: `0xee1a1a1a`
        color: impl Into<LuaValue> => LuaValue,

        // TODO: unset/fallback is clearer as Option<Color>.
        /// Inactive shadow color. If unset, falls back to `color`.
        ///
        /// Default: unset
        color_inactive: impl Into<LuaValue> => LuaValue,

        /// Shadow rendering offset.
        ///
        /// Default: `[0, 0]`
        offset: impl Into<Vec2> => Vec2,

        /// Shadow scale.
        ///
        /// Default: `1.0`
        scale: f64 => f64,
    }

    // TODO: subcategory path is `decoration.glow`.
    DecorationGlow decoration_glow {
        /// Enables inner glow on windows.
        ///
        /// Default: `false`
        enabled: bool => bool,

        /// Glow range or size in layout pixels.
        ///
        /// Default: `10`
        range: u32 => u32,

        /// Power used to render glow falloff.
        ///
        /// Default: `3`
        render_power: u32 => u32,

        // TODO: color should probably get a real Rust type instead of raw LuaValue.
        /// Glow color. Alpha controls glow opacity.
        ///
        /// Default: `0xee1a1a1a`
        color: impl Into<LuaValue> => LuaValue,

        // TODO: unset/fallback is clearer as Option<Color>.
        /// Inactive glow color. If unset, falls back to `color`.
        ///
        /// Default: unset
        color_inactive: impl Into<LuaValue> => LuaValue,
    }

    Animations animations {
        /// Enables animations.
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Enables workspace wraparound, making directional workspace animations treat the first
        /// and last workspaces as adjacent.
        ///
        /// Default: `false`
        workspace_wraparound: bool => bool,
    }

    Input input {
        /// XKB keymap model parameter.
        ///
        /// Default: `""`
        kb_model: impl Into<String> => String,

        /// XKB keymap layout parameter.
        ///
        /// Default: `"us"`
        kb_layout: impl Into<String> => String,

        /// XKB keymap variant parameter.
        ///
        /// Default: `""`
        kb_variant: impl Into<String> => String,

        /// XKB keymap options parameter.
        ///
        /// Default: `""`
        kb_options: impl Into<String> => String,

        /// XKB keymap rules parameter.
        ///
        /// Default: `""`
        kb_rules: impl Into<String> => String,

        /// Path to a custom `.xkb` file.
        ///
        /// Default: `""`
        kb_file: impl Into<String> => String,

        /// Enables numlock by default.
        ///
        /// Default: `false`
        numlock_by_default: bool => bool,

        /// Resolves keybinds by typed symbol when multiple layouts are used.
        ///
        /// Default: `false`
        resolve_binds_by_sym: bool => bool,

        /// Repeat rate for held-down keys, in repeats per second.
        ///
        /// Default: `25`
        repeat_rate: u32 => u32,

        /// Delay before a held-down key repeats.
        ///
        /// Default: `600ms`
        repeat_delay: Duration => DurationMs,

        /// Mouse input sensitivity, clamped to `-1.0..=1.0`.
        ///
        /// Default: `0.0`
        sensitivity: f64 => f64,

        // TODO: enum or richer custom accel profile builder: adaptive/flat/custom <step> <points...>.
        /// Cursor acceleration profile. Empty means libinput default.
        ///
        /// Default: `""`
        accel_profile: impl Into<String> => String,

        /// Forces no cursor acceleration, bypassing most pointer settings.
        ///
        /// Default: `false`
        force_no_accel: bool => bool,

        /// Device rotation in degrees clockwise from logical neutral position.
        ///
        /// Default: `0`
        rotation: u32 => u32,

        /// Switches right and left mouse buttons.
        ///
        /// Default: `false`
        left_handed: bool => bool,

        // TODO: structured custom scroll acceleration curve.
        /// Scroll acceleration profile when `accel_profile` is `custom`.
        ///
        /// Default: `""`
        scroll_points: impl Into<String> => String,

        // TODO: enum: 2fg/edge/on_button_down/no_scroll.
        /// Scroll method.
        ///
        /// Default: `""`
        scroll_method: impl Into<String> => String,

        // TODO: button-id newtype would be nicer.
        /// Scroll button ID. `0` means default.
        ///
        /// Default: `0`
        scroll_button: u32 => u32,

        /// If enabled, pressing and releasing the scroll button toggles logical hold state.
        ///
        /// Default: `false`
        scroll_button_lock: bool => bool,

        /// Scroll movement multiplier for external mice.
        ///
        /// Default: `1.0`
        scroll_factor: f64 => f64,

        /// Inverts scrolling direction.
        ///
        /// Default: `false`
        natural_scroll: bool => bool,

        /// Specifies if and how cursor movement affects window focus.
        ///
        /// Default: [`FollowMouse::Always`]
        follow_mouse: FollowMouse => i32,

        /// Shrinks inactive window hitboxes for focus detection.
        ///
        /// Only works with `follow_mouse = 1`.
        ///
        /// Default: `0`
        follow_mouse_shrink: u32 => u32,

        /// Smallest distance in logical pixels the mouse must travel before focusing the window
        /// under it.
        ///
        /// Only works with `follow_mouse = 1`.
        ///
        /// Default: `0.0`
        follow_mouse_threshold: f64 => f64,

        /// Controls focus behavior when a window is closed.
        ///
        /// Default: [`FocusOnClose::NextCandidate`]
        focus_on_close: FocusOnClose => i32,

        /// If disabled, mouse focus will not switch to a hovered window unless the mouse crosses a
        /// window boundary when `follow_mouse = 1`.
        ///
        /// Default: `true`
        mouse_refocus: bool => bool,

        // TODO: enum: disabled/enabled/enabled_float_to_float.
        /// Controls whether focus changes to the window under the cursor when switching between
        /// tiled and floating states.
        ///
        /// Default: `1`
        float_switch_override_focus: u32 => u32,

        /// If enabled, having only floating windows in the special workspace will not block focus
        /// from falling through to the regular workspace.
        ///
        /// Default: `false`
        special_fallthrough: bool => bool,

        // TODO: enum for 0/1/2/3 axis-event behavior.
        /// Handles axis events around a focused window.
        ///
        /// Default: `1`
        off_window_axis_events: u32 => u32,

        // TODO: enum: disabled/non_standard_only/force_all.
        /// Emulates discrete scrolling from high-resolution scrolling events.
        ///
        /// Default: `1`
        emulate_discrete_scroll: u32 => u32,
    }

    // TODO: subcategory path is `input.touchpad`.
    InputTouchpad input_touchpad {
        /// Disables the touchpad while typing.
        ///
        /// Default: `true`
        disable_while_typing: bool => bool,

        /// Inverts scrolling direction.
        ///
        /// Default: `false`
        natural_scroll: bool => bool,

        /// Scroll movement multiplier.
        ///
        /// Default: `1.0`
        scroll_factor: f64 => f64,

        /// Interprets simultaneous left and right click as middle click.
        ///
        /// Default: `false`
        middle_button_emulation: bool => bool,

        // TODO: enum: lrm/lmr.
        /// Tap button mapping for touchpad button emulation.
        ///
        /// Default: `""`
        tap_button_map: impl Into<String> => String,

        /// Enables clickfinger behavior.
        ///
        /// Default: `false`
        clickfinger_behavior: bool => bool,

        /// Enables tap-to-click.
        ///
        /// Default: `true`
        tap_to_click: bool => bool,

        // TODO: enum: disabled / timeout / sticky.
        /// Controls whether lifting the finger while dragging drops the dragged item.
        ///
        /// Default: `0`
        drag_lock: u32 => u32,

        /// Enables tap-and-drag mode.
        ///
        /// Default: `true`
        tap_and_drag: bool => bool,

        /// Inverts horizontal touchpad movement.
        ///
        /// Default: `false`
        flip_x: bool => bool,

        /// Inverts vertical touchpad movement.
        ///
        /// Default: `false`
        flip_y: bool => bool,

        // TODO: enum: disabled / three_fingers / four_fingers.
        /// Enables three- or four-finger drag.
        ///
        /// Default: `0`
        drag_3fg: u32 => u32,
    }

    // TODO: subcategory path is `input.touchdevice`.
    InputTouchdevice input_touchdevice {
        // TODO: monitor transform enum; `-1` is unset.
        /// Transform for touch device input.
        ///
        /// Default: `-1`
        transform: i32 => i32,

        // TODO: auto-detect vs empty string vs monitor name deserves a typed wrapper.
        /// Monitor to bind touch devices to. Default is auto-detection.
        ///
        /// Default: auto
        output: impl Into<String> => String,

        /// Whether touch device input is enabled.
        ///
        /// Default: `true`
        enabled: bool => bool,
    }

    // TODO: subcategory path is `input.virtualkeyboard`.
    InputVirtualkeyboard input_virtualkeyboard {
        // TODO: enum: no / yes / yes_unless_ime_client.
        /// Controls whether key down states and modifier states are unified with other keyboards.
        ///
        /// Default: `2`
        share_states: u32 => u32,

        /// Releases all keys pressed by the virtual keyboard when it closes.
        ///
        /// Default: `false`
        release_pressed_on_close: bool => bool,
    }

    // TODO: subcategory path is `input.tablet`.
    InputTablet input_tablet {
        // TODO: monitor transform enum; `-1` is unset.
        /// Transform for tablet input.
        ///
        /// Default: `-1`
        transform: i32 => i32,

        // TODO: enum/string wrapper: current / monitor name / empty for all.
        /// Monitor to bind tablets to. Can be `current`, a monitor name, or empty for all
        /// monitors.
        ///
        /// Default: `""`
        output: impl Into<String> => String,

        /// Position of the mapped region in monitor layout.
        ///
        /// Default: `[0, 0]`
        region_position: impl Into<Vec2> => Vec2,

        /// Treats `region_position` as an absolute position in monitor layout.
        ///
        /// Default: `false`
        absolute_region_position: bool => bool,

        /// Size of the mapped region. `[0, 0]` or invalid size means unset.
        ///
        /// Default: `[0, 0]`
        region_size: impl Into<Vec2> => Vec2,

        /// Enables relative tablet input.
        ///
        /// Default: `false`
        relative_input: bool => bool,

        /// Rotates the tablet 180 degrees.
        ///
        /// Default: `false`
        left_handed: bool => bool,

        /// Size of the tablet active area in millimeters.
        ///
        /// Default: `[0, 0]`
        active_area_size: impl Into<Vec2> => Vec2,

        /// Position of the tablet active area in millimeters.
        ///
        /// Default: `[0, 0]`
        active_area_position: impl Into<Vec2> => Vec2,
    }

    Gestures gestures {
        /// Distance of the touchpad gesture, in pixels.
        ///
        /// Default: `300`
        workspace_swipe_distance: u32 => u32,

        /// Enables workspace swiping from the edge of a touchscreen.
        ///
        /// Default: `false`
        workspace_swipe_touch: bool => bool,

        /// Inverts workspace swipe direction for touchpads.
        ///
        /// Default: `true`
        workspace_swipe_invert: bool => bool,

        /// Inverts workspace swipe direction for touchscreens.
        ///
        /// Default: `false`
        workspace_swipe_touch_invert: bool => bool,

        /// Minimum speed to force workspace change, ignoring `workspace_swipe_cancel_ratio`.
        ///
        /// Default: `30`
        workspace_swipe_min_speed_to_force: u32 => u32,

        /// How far the swipe must proceed before switching workspace.
        ///
        /// Default: `0.5`
        workspace_swipe_cancel_ratio: f64 => f64,

        /// Whether a swipe right on the last workspace creates a new workspace.
        ///
        /// Default: `true`
        workspace_swipe_create_new: bool => bool,

        /// Locks swipe direction after passing `workspace_swipe_direction_lock_threshold`.
        ///
        /// Default: `true`
        workspace_swipe_direction_lock: bool => bool,

        /// Distance before swipe direction lock activates, in pixels.
        ///
        /// Default: `10`
        workspace_swipe_direction_lock_threshold: u32 => u32,

        /// Allows swiping to continue beyond neighboring workspaces.
        ///
        /// Default: `false`
        workspace_swipe_forever: bool => bool,

        /// Uses the `r` prefix instead of the `m` prefix for finding workspaces.
        ///
        /// Default: `false`
        workspace_swipe_use_r: bool => bool,

        /// Timeout for a window to close when using a 1:1 gesture.
        ///
        /// Default: `1000ms`
        close_max_timeout: Duration => DurationMs,
    }

    Group group {
        /// Whether new windows are automatically grouped into the focused unlocked group.
        ///
        /// Default: `true`
        auto_group: bool => bool,

        /// Whether new windows in a group spawn after the current window or at the group tail.
        ///
        /// Default: `true`
        insert_after_current: bool => bool,

        /// Whether Hyprland focuses the window that was just moved out of the group.
        ///
        /// Default: `true`
        focus_removed_window: bool => bool,

        // TODO: enum: disabled/enabled/only_groupbar.
        /// Whether dragging a window into an unlocked group merges them.
        ///
        /// Default: `1`
        drag_into_group: u32 => u32,

        /// Whether window groups can be dragged into other groups.
        ///
        /// Default: `true`
        merge_groups_on_drag: bool => bool,

        /// Whether one group merges with another when dragged into its groupbar.
        ///
        /// Default: `true`
        merge_groups_on_groupbar: bool => bool,

        /// Whether dragging a floating window into a tiled window groupbar merges them.
        ///
        /// Default: `false`
        merge_floated_into_tiled_on_groupbar: bool => bool,

        /// Whether `movetoworkspace` merges a window into the workspace’s solitary unlocked group.
        ///
        /// Default: `false`
        group_on_movetoworkspace: bool => bool,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Active group border color.
        ///
        /// Default: `0x66ffff00`
        col_border_active: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Inactive group border color.
        ///
        /// Default: `0x66777700`
        col_border_inactive: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Active locked group border color.
        ///
        /// Default: `0x66ff5500`
        col_border_locked_active: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Inactive locked group border color.
        ///
        /// Default: `0x66775500`
        col_border_locked_inactive: impl Into<LuaValue> => LuaValue,
    }

    // TODO: subcategory path is `group.groupbar`.
    Groupbar groupbar {
        /// Enables groupbars.
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Font used for groupbar titles. Uses `misc.font_family` if unspecified.
        ///
        /// Default: `""`
        font_family: impl Into<String> => String,

        /// Font size of groupbar titles.
        ///
        /// Default: `8`
        font_size: u32 => u32,

        // TODO: font_weight allows int 100..=1000 or named presets.
        /// Font weight of the active groupbar title.
        ///
        /// Default: `normal`
        font_weight_active: FontWeight => i32,

        // TODO: font_weight allows int 100..=1000 or named presets.
        /// Font weight of the inactive groupbar title.
        ///
        /// Default: `normal`
        font_weight_inactive: FontWeight => i32,

        /// Enables gradients.
        ///
        /// Default: `false`
        gradients: bool => bool,

        /// Height of the groupbar.
        ///
        /// Default: `14`
        height: u32 => u32,

        /// Height of the gap between the groupbar indicator and title.
        ///
        /// Default: `0`
        indicator_gap: u32 => u32,

        /// Height of the groupbar indicator.
        ///
        /// Default: `3`
        indicator_height: u32 => u32,

        /// Renders the groupbar as a vertical stack.
        ///
        /// Default: `false`
        stacked: bool => bool,

        /// Decoration priority for groupbars.
        ///
        /// Default: `3`
        priority: u32 => u32,

        /// Whether to render titles in the groupbar decoration.
        ///
        /// Default: `true`
        render_titles: bool => bool,

        /// Vertical title position adjustment.
        ///
        /// Default: `0`
        text_offset: i32 => i32,

        /// Horizontal title padding.
        ///
        /// Default: `0`
        text_padding: u32 => u32,

        /// Whether scrolling in the groupbar changes the active group window.
        ///
        /// Default: `true`
        scrolling: bool => bool,

        /// How much to round the indicator.
        ///
        /// Default: `1`
        rounding: u32 => u32,

        /// Curve used for rounding groupbar corners.
        ///
        /// Default: `2.0`
        rounding_power: f64 => f64,

        /// How much to round gradients.
        ///
        /// Default: `2`
        gradient_rounding: u32 => u32,

        /// Curve used for rounding gradient corners.
        ///
        /// Default: `2.0`
        gradient_rounding_power: f64 => f64,

        /// Rounds only the indicator edges of the entire groupbar.
        ///
        /// Default: `true`
        round_only_edges: bool => bool,

        /// Rounds only the gradient edges of the entire groupbar.
        ///
        /// Default: `true`
        gradient_round_only_edges: bool => bool,

        // TODO: color should probably get a real Rust type instead of raw LuaValue.
        /// Color for window titles in the groupbar.
        ///
        /// Default: `0xffffffff`
        text_color: impl Into<LuaValue> => LuaValue,

        // TODO: unset/fallback is clearer as Option<Color>.
        /// Color for inactive window titles in the groupbar.
        ///
        /// Default: unset
        text_color_inactive: impl Into<LuaValue> => LuaValue,

        // TODO: unset/fallback is clearer as Option<Color>.
        /// Color for the active window title in a locked group.
        ///
        /// Default: unset
        text_color_locked_active: impl Into<LuaValue> => LuaValue,

        // TODO: unset/fallback is clearer as Option<Color>.
        /// Color for inactive window titles in locked groups.
        ///
        /// Default: unset
        text_color_locked_inactive: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Active groupbar background color.
        ///
        /// Default: `0x66ffff00`
        col_active: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Inactive groupbar background color.
        ///
        /// Default: `0x66777700`
        col_inactive: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Active locked groupbar background color.
        ///
        /// Default: `0x66ff5500`
        col_locked_active: impl Into<LuaValue> => LuaValue,

        // TODO: gradient/color should probably get a real Rust type instead of raw LuaValue.
        /// Inactive locked groupbar background color.
        ///
        /// Default: `0x66775500`
        col_locked_inactive: impl Into<LuaValue> => LuaValue,

        /// Gap size between gradients.
        ///
        /// Default: `2`
        gaps_in: u32 => u32,

        /// Gap size between gradients and window.
        ///
        /// Default: `2`
        gaps_out: u32 => u32,

        /// Adds or removes the upper gap.
        ///
        /// Default: `true`
        keep_upper_gap: bool => bool,

        /// Whether middle-clicking the groupbar closes the clicked window.
        ///
        /// Default: `true`
        middle_click_close: bool => bool,

        /// Applies blur to groupbar indicators and gradients.
        ///
        /// Default: `false`
        blur: bool => bool,
    }

    Misc misc {
        /// Disables the random Hyprland logo / anime girl background.
        ///
        /// Default: `false`
        disable_hyprland_logo: bool => bool,

        /// Disables Hyprland splash rendering.
        ///
        /// Default: `false`
        disable_splash_rendering: bool => bool,

        /// Disables the notification popup when a monitor fails to set a suitable scale.
        ///
        /// Default: `false`
        disable_scale_notification: bool => bool,

        // TODO: color should probably get a real Rust type instead of raw LuaValue.
        /// Splash text color.
        ///
        /// Default: `0xffffffff`
        col_splash: impl Into<LuaValue> => LuaValue,

        /// Global default font for debug FPS, notifications, config errors, and similar text.
        ///
        /// Default: `"Sans"`
        font_family: impl Into<String> => String,

        /// Font used to render splash text.
        ///
        /// Default: `""`
        splash_font_family: impl Into<String> => String,

        // TODO: enum: random / disabled variants / wallpaper 2.
        /// Enforces one of the default wallpapers.
        ///
        /// Default: `-1`
        force_default_wallpaper: i32 => i32,

        // TODO: enum: off/on/fullscreen/fullscreen_video_or_game.
        /// Controls VRR / Adaptive Sync for monitors.
        ///
        /// Default: `0`
        vrr: u32 => u32,

        /// Wakes monitors when the mouse moves if DPMS is off.
        ///
        /// Default: `false`
        mouse_move_enables_dpms: bool => bool,

        /// Wakes monitors when a key is pressed if DPMS is off.
        ///
        /// Default: `false`
        key_press_enables_dpms: bool => bool,

        /// Names virtual keyboards after the processes that create them.
        ///
        /// Default: `true`
        name_vk_after_proc: bool => bool,

        /// Makes mouse focus follow the mouse during drag-and-drop.
        ///
        /// Default: `true`
        always_follow_on_dnd: bool => bool,

        /// Makes keyboard-interactive layers keep focus on mouse move.
        ///
        /// Default: `true`
        layers_hog_keyboard_focus: bool => bool,

        /// Animates manual window resizes and moves.
        ///
        /// Default: `false`
        animate_manual_resizes: bool => bool,

        /// Animates windows being dragged by mouse.
        ///
        /// Default: `false`
        animate_mouse_windowdragging: bool => bool,

        /// Disables automatic config reload on save.
        ///
        /// Default: `false`
        disable_autoreload: bool => bool,

        /// Enables window swallowing.
        ///
        /// Default: `false`
        enable_swallow: bool => bool,

        // TODO: regex wrapper could be useful.
        /// Class regex for windows that should be swallowed.
        ///
        /// Default: `""`
        swallow_regex: impl Into<String> => String,

        // TODO: regex wrapper could be useful.
        /// Title regex for windows that should not be swallowed.
        ///
        /// Default: `""`
        swallow_exception_regex: impl Into<String> => String,

        /// Whether Hyprland should focus an app that sends an activate request.
        ///
        /// Default: `false`
        focus_on_activate: bool => bool,

        /// Whether moving the mouse into a different monitor should focus it.
        ///
        /// Default: `true`
        mouse_move_focuses_monitor: bool => bool,

        /// Allows restarting a lockscreen app if it crashes.
        ///
        /// Default: `false`
        allow_session_lock_restore: bool => bool,

        /// Keeps rendering workspaces below the lockscreen.
        ///
        /// Default: `false`
        session_lock_xray: bool => bool,

        // TODO: color should probably get a real Rust type instead of raw LuaValue.
        /// Background color. Requires `disable_hyprland_logo`.
        ///
        /// Default: `0x111111`
        background_color: impl Into<LuaValue> => LuaValue,

        /// Closes the special workspace when its last window is removed.
        ///
        /// Default: `true`
        close_special_on_empty: bool => bool,

        // TODO: enum: ignore/take_over/unfullscreen.
        /// Controls focus requests under fullscreen or maximized windows.
        ///
        /// Default: `2`
        on_focus_under_fullscreen: u32 => u32,

        /// Makes the next focused window fullscreen after closing a fullscreen window.
        ///
        /// Default: `false`
        exit_window_retains_fullscreen: bool => bool,

        // TODO: enum: disabled/single_shot/persistent.
        /// Controls whether windows open on the workspace they were invoked on.
        ///
        /// Default: `1`
        initial_workspace_tracking: u32 => u32,

        /// Enables middle-click paste / primary selection.
        ///
        /// Default: `true`
        middle_click_paste: bool => bool,

        /// FPS limit for background `render_unfocused` windows.
        ///
        /// Default: `15`
        render_unfocused_fps: u32 => u32,

        /// Disables the warning if XDG environment is externally managed.
        ///
        /// Default: `false`
        disable_xdg_env_checks: bool => bool,

        /// Disables the warning if hyprland-qtutils is not installed.
        ///
        /// Default: `false`
        disable_hyprland_qtutils_check: bool => bool,

        /// Delay before the lockdead screen appears if a lockscreen app fails to cover all outputs.
        ///
        /// Default: `1000ms`
        lockdead_screen_delay: Duration => DurationMs,

        /// Enables the app-not-responding dialog.
        ///
        /// Default: `true`
        enable_anr_dialog: bool => bool,

        /// Number of missed pings before showing the app-not-responding dialog.
        ///
        /// Default: `5`
        anr_missed_pings: u32 => u32,

        /// Applies `min_size` and `max_size` rules to tiled windows.
        ///
        /// Default: `false`
        size_limits_tiled: bool => bool,

        /// Disables the warning about not using `start-hyprland`.
        ///
        /// Default: `false`
        disable_watchdog_warning: bool => bool,
    }

    Layout layout {
        /// Adds padding for a single window so it conforms to the specified aspect ratio.
        ///
        /// Default: `[0, 0]`
        single_window_aspect_ratio: impl Into<Vec2> => Vec2,

        // TODO: wiki says type int but default is `0.1` and range is `0..=1`; this should be float.
        /// Tolerance for `single_window_aspect_ratio`.
        ///
        /// Default: `0.1`
        single_window_aspect_ratio_tolerance: f64 => f64,
    }

    Binds binds {
        /// If disabled, will not pass mouse events to apps or window dragging if a keybind has
        /// been triggered.
        ///
        /// Default: `false`
        pass_mouse_when_bound: bool => bool,

        /// How long to wait after a scroll event before allowing another one through for binds.
        ///
        /// Default: `300ms`
        scroll_event_delay: Duration => DurationMs,

        /// If enabled, attempting to switch to the currently focused workspace switches to the
        /// previous workspace instead.
        ///
        /// Default: `false`
        workspace_back_and_forth: bool => bool,

        /// If enabled, changing the active workspace hides the special workspace on the monitor
        /// where the newly active workspace resides.
        ///
        /// Default: `false`
        hide_special_on_workspace_change: bool => bool,

        /// If enabled, workspaces do not forget their previous workspace, so cycles can be created.
        ///
        /// Default: `false`
        allow_workspace_cycles: bool => bool,

        /// Whether switching workspaces centers the cursor on the workspace or on the last active
        /// window for that workspace.
        ///
        /// Default: [`WorkspaceCenterOn::Workspace`]
        workspace_center_on: WorkspaceCenterOn => i32,

        /// Preferred focus finding method for directional focus and window movement dispatchers.
        ///
        /// Default: [`FocusPreferredMethod::History`]
        focus_preferred_method: FocusPreferredMethod => i32,

        // TODO: refer to the Rust methods in these docs.
        /// If enabled, group movement dispatchers ignore the per-group lock.
        ///
        /// Default: `false`
        ignore_group_lock: bool => bool,

        /// If enabled, directional focus on a fullscreen window cycles fullscreen instead of moving
        /// focus directionally.
        ///
        /// Default: `false`
        movefocus_cycles_fullscreen: bool => bool,

        /// If enabled, directional focus inside a group cycles group windows first.
        ///
        /// Default: `false`
        movefocus_cycles_groupfirst: bool => bool,

        /// If enabled, moving a window or focus over the edge of a monitor moves it to the next
        /// monitor in that direction.
        ///
        /// Default: `true`
        window_direction_monitor_fallback: bool => bool,

        /// If enabled, apps that request keybinds to be disabled, such as VMs, cannot do so.
        ///
        /// Default: `false`
        disable_keybind_grabbing: bool => bool,

        /// If enabled, allows fullscreen for pinned windows and restores their pinned status after.
        ///
        /// Default: `false`
        allow_pin_fullscreen: bool => bool,

        // TODO: use Option? `0` disables and grabs on mousedown.
        /// Movement threshold in pixels for window dragging and `c`/`g` bind flags.
        ///
        /// Default: `0`
        drag_threshold: u32 => u32,
    }

    XWayland xwayland {
        /// Allows running X11 applications.
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Uses nearest-neighbor filtering for XWayland apps, making them pixelated rather than
        /// blurry.
        ///
        /// Default: `true`
        use_nearest_neighbor: bool => bool,

        /// Forces scale 1 on XWayland windows on scaled displays.
        ///
        /// Default: `false`
        force_zero_scaling: bool => bool,

        /// Creates the abstract Unix domain socket for XWayland connections.
        ///
        /// Default: `false`
        create_abstract_socket: bool => bool,
    }

    OpenGL opengl {
        /// Reduces flickering on Nvidia at the cost of possible frame drops on lower-end GPUs.
        ///
        /// Default: `true`
        nvidia_anti_flicker: bool => bool,
    }

    Render render {
        // TODO: enum: off/on/auto_game.
        /// Enables direct scanout to reduce lag for single fullscreen applications.
        ///
        /// Default: `0`
        direct_scanout: u32 => u32,

        /// Expands undersized textures along the edge instead of stretching the entire texture.
        ///
        /// Default: `true`
        expand_undersized_textures: bool => bool,

        /// Disables back buffer and bottom layer rendering.
        ///
        /// Default: `false`
        xp_mode: bool => bool,

        // TODO: enum: off/on/auto_nvidia.
        /// Enables fade animation for CTM changes.
        ///
        /// Default: `2`
        ctm_animation: u32 => u32,

        /// Enables the color management pipeline.
        ///
        /// Default: `true`
        cm_enabled: bool => bool,

        /// Reports content type to allow monitor profile autoswitch.
        ///
        /// Default: `true`
        send_content_type: bool => bool,

        // TODO: enum: off/hdr/hdredid.
        /// Auto-switches to HDR in fullscreen when needed.
        ///
        /// Default: `1`
        cm_auto_hdr: u32 => u32,

        /// Automatically uses triple buffering when needed.
        ///
        /// Default: `false`
        new_render_scheduling: bool => bool,

        // TODO: enum for non-shader color-management modes.
        /// Enables color management without shader.
        ///
        /// Default: `2`
        non_shader_cm: u32 => u32,

        // TODO: enum for CTM interop behavior.
        /// Controls external CTM behavior in fullscreen.
        ///
        /// Default: `2`
        non_shader_cm_interop: u32 => u32,

        // TODO: enum: default/gamma22/gamma22force/srgb.
        /// Default transfer function for displaying SDR apps.
        ///
        /// Default: `"default"`
        cm_sdr_eotf: impl Into<String> => String,

        /// Enables commit timing protocol.
        ///
        /// Default: `true`
        commit_timing_enabled: bool => bool,

        // TODO: enum: disabled/enabled/enabled_in_hdr.
        /// Uses FP16 buffers internally.
        ///
        /// Default: `2`
        use_fp16: u32 => u32,

        // TODO: enum: disabled/on/auto_hdr_sdr_modifiers.
        /// Keeps an unmodified SDR frame copy for screensharing.
        ///
        /// Default: `2`
        keep_unmodified_copy: u32 => u32,

        /// Uses experimental blurred background blending.
        ///
        /// Default: `false`
        use_shader_blur_blend: bool => bool,
    }

    Cursor cursor {
        /// Does not render cursors.
        ///
        /// Default: `false`
        invisible: bool => bool,

        /// Syncs xcursor theme and size with gsettings.
        ///
        /// Default: `true`
        sync_gsettings_theme: bool => bool,

        // TODO: enum: use_hw/disable_hw/auto_disable_when_tearing.
        /// Controls hardware cursor usage.
        ///
        /// Default: `2`
        no_hardware_cursors: u32 => u32,

        // TODO: enum: off/on/auto_game.
        /// Avoids scheduling new frames on cursor movement for fullscreen apps with VRR enabled.
        ///
        /// Default: `2`
        no_break_fs_vrr: u32 => u32,

        /// Minimum refresh rate for cursor movement when `no_break_fs_vrr` is active.
        ///
        /// Default: `24`
        min_refresh_rate: u32 => u32,

        /// Padding in logical pixels between screen edges and the cursor.
        ///
        /// Default: `1`
        hotspot_padding: u32 => u32,

        /// Cursor inactivity timeout before hiding, in seconds. `0` means never.
        ///
        /// Default: `0`
        inactive_timeout: f64 => f64,

        /// Prevents cursor warping in many cases.
        ///
        /// Default: `false`
        no_warps: bool => bool,

        /// Returns the cursor to its last position relative to a refocused window.
        ///
        /// Default: `false`
        persistent_warps: bool => bool,

        // TODO: enum: disabled/enabled/force.
        /// Moves the cursor to the last focused window after changing workspace.
        ///
        /// Default: `0`
        warp_on_change_workspace: u32 => u32,

        // TODO: enum: disabled/enabled/force.
        /// Moves the cursor to the last focused window when toggling a special workspace.
        ///
        /// Default: `0`
        warp_on_toggle_special: u32 => u32,

        /// Name of the default monitor for cursor placement on startup.
        ///
        /// Default: `""`
        default_monitor: impl Into<String> => String,

        /// Zoom factor around the cursor.
        ///
        /// Default: `1.0`
        zoom_factor: f64 => f64,

        /// Makes zoom follow the cursor rigidly.
        ///
        /// Default: `false`
        zoom_rigid: bool => bool,

        /// Detaches the camera from the mouse when zoomed in.
        ///
        /// Default: `true`
        zoom_detached_camera: bool => bool,

        /// Enables hyprcursor support.
        ///
        /// Default: `true`
        enable_hyprcursor: bool => bool,

        /// Hides the cursor on key press until the mouse is moved.
        ///
        /// Default: `false`
        hide_on_key_press: bool => bool,

        /// Hides the cursor after touch input until mouse input occurs.
        ///
        /// Default: `true`
        hide_on_touch: bool => bool,

        /// Hides the cursor after tablet input until mouse input occurs.
        ///
        /// Default: `true`
        hide_on_tablet: bool => bool,

        // TODO: enum: off/on/auto_nvidia.
        /// Makes hardware cursors use a CPU buffer.
        ///
        /// Default: `2`
        use_cpu_buffer: u32 => u32,

        /// Warps the cursor back after using non-mouse input to move it and returning to mouse.
        ///
        /// Default: `false`
        warp_back_after_non_mouse_input: bool => bool,

        /// Disables antialiasing when zooming.
        ///
        /// Default: `false`
        zoom_disable_aa: bool => bool,
    }

    Ecosystem ecosystem {
        /// Disables the popup shown after updating Hyprland.
        ///
        /// Default: `false`
        no_update_news: bool => bool,

        /// Disables the twice-yearly donation nag popup.
        ///
        /// Default: `false`
        no_donation_nag: bool => bool,

        /// Enables permission control.
        ///
        /// Default: `false`
        enforce_permissions: bool => bool,
    }

    Quirks quirks {
        // TODO: enum: off/always/gamescope_only.
        /// Reports HDR mode as preferred.
        ///
        /// Default: `0`
        prefer_hdr: u32 => u32,
    }

    Debug debug {
        /// Prints the debug performance overlay.
        ///
        /// Default: `false`
        overlay: bool => bool,

        /// Flashes areas updated with damage tracking.
        ///
        /// Default: `false`
        damage_blink: bool => bool,

        /// Enables OpenGL debugging with `glGetError` and `EGL_KHR_debug`.
        ///
        /// Default: `false`
        gl_debugging: bool => bool,

        /// Controls VFR status.
        ///
        /// Default: `true`
        vfr: bool => bool,

        /// Disables logging to a file.
        ///
        /// Default: `true`
        disable_logs: bool => bool,

        /// Disables time logging.
        ///
        /// Default: `true`
        disable_time: bool => bool,

        // TODO: enum: none/monitor/full.
        /// Controls damage tracking.
        ///
        /// Default: `2`
        damage_tracking: u32 => u32,

        /// Enables logging to stdout.
        ///
        /// Default: `false`
        enable_stdout_logs: bool => bool,

        /// Set to `1` and then back to `0` to crash Hyprland.
        ///
        /// Default: `0`
        manual_crash: u32 => u32,

        /// Suppresses config file parsing errors.
        ///
        /// Default: `false`
        suppress_errors: bool => bool,

        /// Timeout for watchdog aborting signal processing on the main thread.
        ///
        /// Default: `5s`
        watchdog_timeout: Duration => DurationSecs,

        /// Disables verification of scale factors.
        ///
        /// Default: `false`
        disable_scale_checks: bool => bool,

        /// Limits the number of displayed config file parsing errors.
        ///
        /// Default: `5`
        error_limit: u32 => u32,

        // TODO: enum: top/bottom.
        /// Position of the error bar.
        ///
        /// Default: `0`
        error_position: u32 => u32,

        /// Enables colors in stdout logs.
        ///
        /// Default: `true`
        colored_stdout_logs: bool => bool,

        // TODO: field name `pass` is a Rust keyword; macro must support raw identifiers or rename mapping.
        /// Enables render pass debugging.
        ///
        /// Default: `false`
        r#pass: bool => bool,

        /// Claims support for all color-management protocol features.
        ///
        /// Default: `false`
        full_cm_proto: bool => bool,

        // TODO: enum: not_allowed/allowed/not_allowed_on_nvidia.
        /// Allows FP16 buffer invalidation.
        ///
        /// Default: `2`
        invalidate_fp16: u32 => u32,
    }

    Dwindle dwindle {
        // TODO: enum: follows_mouse / always_left_or_top / always_right_or_bottom.
        /// Controls forced split direction.
        ///
        /// Default: `0`
        force_split: u32 => u32,

        /// Preserves split orientation regardless of what happens to the container.
        ///
        /// Default: `false`
        preserve_split: bool => bool,

        /// Enables cursor-position-based split direction control.
        ///
        /// Also turns on `preserve_split`.
        ///
        /// Default: `false`
        smart_split: bool => bool,

        /// Determines resize direction using mouse position instead of tiling position.
        ///
        /// Default: `true`
        smart_resizing: bool => bool,

        /// Keeps preselect direction active until changed or disabled.
        ///
        /// Default: `false`
        permanent_direction_override: bool => bool,

        /// Scale factor of windows on the special workspace.
        ///
        /// Default: `1`
        special_scale_factor: f64 => f64,

        /// Auto-split width multiplier.
        ///
        /// Default: `1.0`
        split_width_multiplier: f64 => f64,

        /// Whether to prefer the active window or mouse position for splits.
        ///
        /// Default: `true`
        use_active_for_splits: bool => bool,

        /// Default split ratio on window open.
        ///
        /// `1.0` means an even `50/50` split.
        ///
        /// Default: `1.0`
        default_split_ratio: f64 => f64,

        // TODO: enum: directional/current_window.
        /// Specifies which window receives the split ratio.
        ///
        /// Default: `0`
        split_bias: u32 => u32,

        /// Makes `bindm` `movewindow` drop the window more precisely based on mouse position.
        ///
        /// Default: `false`
        precise_mouse_move: bool => bool,
    }

    Master master {
        /// Enables adding additional master windows in a horizontal split style.
        ///
        /// Default: `false`
        allow_small_split: bool => bool,

        /// Scale of special workspace windows.
        ///
        /// Default: `1`
        special_scale_factor: f64 => f64,

        /// Size of the master area as a percentage of the screen.
        ///
        /// Default: `0.55`
        mfact: f64 => f64,

        // TODO: enum: master/slave/inherit.
        /// Determines whether new windows become master, slave, or inherit from the focused window.
        ///
        /// Default: `"slave"`
        new_status: impl Into<String> => String,

        /// Whether a newly opened window appears on top of the stack.
        ///
        /// Default: `false`
        new_on_top: bool => bool,

        // TODO: enum: before/after/none.
        /// Places new windows relative to the focused window, or according to `new_on_top`.
        ///
        /// Default: `"none"`
        new_on_active: impl Into<String> => String,

        // TODO: enum: left/right/top/bottom/center.
        /// Default placement of the master area.
        ///
        /// Default: `"left"`
        orientation: impl Into<String> => String,

        /// Minimum number of slave windows before centered master is used.
        ///
        /// `0` means always center master.
        ///
        /// Default: `2`
        slave_count_for_center_master: u32 => u32,

        // TODO: enum: left/right/top/bottom.
        /// Fallback orientation for center master when there are too few slave windows.
        ///
        /// Default: `"left"`
        center_master_fallback: impl Into<String> => String,

        /// Determines resize direction using mouse position instead of tiling position.
        ///
        /// Default: `true`
        smart_resizing: bool => bool,

        /// Places dragged-and-dropped windows at the cursor position.
        ///
        /// Default: `true`
        drop_at_cursor: bool => bool,

        /// Keeps the master window in its configured position when there are no slave windows.
        ///
        /// Default: `false`
        always_keep_position: bool => bool,

        /// Focuses the master window when closing a window.
        ///
        /// Default: `false`
        focus_master_on_close: bool => bool,
    }

    Scrolling scrolling {
        /// Makes a single column on a workspace always span the entire screen.
        ///
        /// Default: `true`
        fullscreen_on_one_column: bool => bool,

        /// Default width of a column.
        ///
        /// Default: `0.5`
        column_width: f64 => f64,

        /// Method used to bring a focused column into view.
        ///
        /// Default: [`ScrollingFocusFitMethod::Fit`]
        focus_fit_method: ScrollingFocusFitMethod => i32,

        /// Moves the layout automatically to bring focused windows into view.
        ///
        /// Default: `true`
        follow_focus: bool => bool,

        /// Fraction of a focused window that must be visible before focus follows.
        ///
        /// Default: `0.4`
        follow_min_visible: f64 => f64,

        // TODO: this wants a `Vec<f64>` or small typed comma-list wrapper.
        /// Comma-separated list of preconfigured widths for `colresize +conf/-conf`.
        ///
        /// Default: `"0.333, 0.5, 0.667, 1.0"`
        explicit_column_widths: impl Into<String> => String,

        /// Allows `focus l/r` layout messages to wrap around.
        ///
        /// Default: `true`
        wrap_focus: bool => bool,

        /// Allows `swapcol l/r` layout messages to wrap around.
        ///
        /// Default: `true`
        wrap_swapcol: bool => bool,

        // TODO: enum: left/right/down/up.
        /// Direction in which new windows appear and the layout scrolls.
        ///
        /// Default: `"right"`
        direction: impl Into<String> => String,
    }
}

enums! {
    /// See [`Binds::workspace_center_on`]
    WorkspaceCenterOn {
        /// Center the cursor on the workspace.
        #[default]
        Workspace = 0,

        /// Center the cursor on the last active window for that workspace.
        LastActiveWindow = 1,
    }

    /// See [`Binds::focus_preferred_method`]
    FocusPreferredMethod {
        /// Recent windows have priority.
        #[default]
        History = 0,

        /// Windows with longer shared edges have priority.
        Length = 1,
    }

    /// See [`Input::follow_mouse`]
    FollowMouse {
        /// Cursor movement will not change focus.
        Disabled = 0,

        /// Cursor movement will always change focus to the window under the cursor.
        #[default]
        Always = 1,

        /// Cursor focus is detached from keyboard focus. Clicking a window moves keyboard focus
        /// to that window.
        Detached = 2,

        /// Cursor focus is completely separate from keyboard focus. Clicking a window does not
        /// change keyboard focus.
        Separate = 3,
    }

    /// See [`Input::focus_on_close`]
    FocusOnClose {
        /// Focus shifts to the next window candidate.
        #[default]
        NextCandidate = 0,

        /// Focus shifts to the window under the cursor.
        WindowUnderCursor = 1,

        /// Focus shifts to the most recently used / active window.
        MostRecentlyUsed = 2,
    }

    /// See [`Input::float_switch_override_focus`]
    FloatSwitchOverrideFocus {
        /// Do not change focus when switching between tiled and floating.
        Disabled = 0,

        /// Focus the window under the cursor when changing between tiled and floating.
        #[default]
        Enabled = 1,

        /// Also follow mouse on float-to-float switches.
        FloatToFloat = 2,
    }

    /// See [`Input::off_window_axis_events`]
    OffWindowAxisEvents {
        /// Ignore axis events outside the focused window.
        Ignore = 0,

        /// Send out-of-bound coordinates.
        #[default]
        SendOutOfBound = 1,

        /// Fake pointer coordinates to the closest point inside the window.
        FakeClosest = 2,

        /// Warp the cursor to the closest point inside the window.
        WarpClosest = 3,
    }

    /// See [`Input::emulate_discrete_scroll`]
    EmulateDiscreteScroll {
        /// Disable discrete scroll emulation.
        Disabled = 0,

        /// Enable handling of non-standard events only.
        #[default]
        NonStandardOnly = 1,

        /// Force all scroll wheel events to be handled.
        ForceAll = 2,
    }

    /// See [`InputTouchpad::drag_lock`]
    TouchpadDragLock {
        /// Disable drag lock.
        #[default]
        Disabled = 0,

        /// Enable drag lock with timeout.
        Timeout = 1,

        /// Enable sticky drag lock.
        Sticky = 2,
    }

    /// See [`InputTouchpad::drag_3fg`]
    TouchpadDrag3fg {
        /// Disable three/four-finger drag.
        #[default]
        Disabled = 0,

        /// Enable three-finger drag.
        ThreeFingers = 1,

        /// Enable four-finger drag.
        FourFingers = 2,
    }

    /// See [`InputVirtualkeyboard::share_states`]
    VirtualKeyboardShareStates {
        /// Do not unify key down states and modifier states with other keyboards.
        No = 0,

        /// Always unify key down states and modifier states with other keyboards.
        Yes = 1,

        /// Unify states unless there is an IME client.
        #[default]
        YesUnlessImeClient = 2,
    }

    /// See [`Group::drag_into_group`]
    DragIntoGroup {
        /// Disable dragging windows into groups.
        Disabled = 0,

        /// Allow dragging windows into unlocked groups.
        #[default]
        Enabled = 1,

        /// Allow dragging windows into groups only through the groupbar.
        GroupbarOnly = 2,
    }

    /// See [`Misc::force_default_wallpaper`]
    ///
    /// TODO: this requires an `i32` enum representation because the default is `-1`.
    ForceDefaultWallpaper {
        /// Pick a random default wallpaper.
        #[default]
        Random = -1,

        /// Disable the anime background.
        DisableAnime0 = 0,

        /// Disable the anime background.
        DisableAnime1 = 1,

        /// Enforce the third default wallpaper.
        Wallpaper2 = 2,
    }

    /// See [`Misc::vrr`]
    Vrr {
        /// Disable VRR / Adaptive Sync.
        #[default]
        Off = 0,

        /// Enable VRR / Adaptive Sync.
        On = 1,

        /// Enable VRR only for fullscreen.
        FullscreenOnly = 2,

        /// Enable VRR for fullscreen windows with `video` or `game` content type.
        FullscreenVideoOrGame = 3,
    }

    /// See [`Misc::on_focus_under_fullscreen`]
    OnFocusUnderFullscreen {
        /// Ignore the focus request and keep focus on the fullscreen window.
        Ignore = 0,

        /// Let the requested tiled window take over focus.
        TakesOver = 1,

        /// Unfullscreen / unmaximize the focused fullscreen or maximized window.
        #[default]
        Unfullscreen = 2,
    }

    /// See [`Misc::initial_workspace_tracking`]
    InitialWorkspaceTracking {
        /// Disable initial workspace tracking.
        Disabled = 0,

        /// Track only the first spawned window.
        #[default]
        SingleShot = 1,

        /// Track all children persistently.
        Persistent = 2,
    }

    /// See [`Render::direct_scanout`]
    DirectScanout {
        /// Disable direct scanout.
        #[default]
        Off = 0,

        /// Enable direct scanout.
        On = 1,

        /// Automatically enable direct scanout for `game` content type.
        AutoGame = 2,
    }

    /// See [`Render::cm_auto_hdr`]
    CmAutoHdr {
        /// Disable auto HDR switching.
        Off = 0,

        /// Switch to `cm, hdr`.
        #[default]
        Hdr = 1,

        /// Switch to `cm, hdredid`.
        HdrEdid = 2,
    }

    /// See [`Render::non_shader_cm`]
    NonShaderCm {
        /// Disable non-shader color management.
        Disabled = 0,

        /// Use non-shader color management whenever possible.
        WheneverPossible = 1,

        /// Use non-shader color management only for direct scanout and passthrough.
        #[default]
        DirectScanoutAndPassthroughOnly = 2,

        /// Disable non-shader color management and ignore color-management issues.
        DisabledIgnoreIssues = 3,
    }

    /// See [`Render::non_shader_cm_interop`]
    NonShaderCmInterop {
        /// Disable external CTM in fullscreen.
        ExternalCtmDisabledFullscreen = 0,

        /// Enable external CTM in fullscreen.
        ExternalCtmEnabledFullscreen = 1,

        /// Disable external CTM for fullscreen photo, video, and game content types.
        #[default]
        DisabledForFullscreenPhotoVideoGame = 2,
    }

    /// See [`Render::use_fp16`]
    UseFp16 {
        /// Disable FP16 buffers.
        Disabled = 0,

        /// Enable FP16 buffers.
        Enabled = 1,

        /// Enable FP16 buffers in HDR mode.
        #[default]
        EnabledInHdr = 2,
    }

    /// See [`Render::keep_unmodified_copy`]
    KeepUnmodifiedCopy {
        /// Disable the unmodified SDR frame copy.
        Disabled = 0,

        /// Always keep an unmodified SDR frame copy.
        On = 1,

        /// Automatically keep a copy in HDR with SDR modifiers.
        #[default]
        AutoHdrSdrModifiers = 2,
    }

    /// See [`Cursor::no_hardware_cursors`]
    NoHardwareCursors {
        /// Use hardware cursors if possible.
        UseHardware = 0,

        /// Do not use hardware cursors.
        Disabled = 1,

        /// Automatically disable hardware cursors when tearing.
        #[default]
        AutoDisableWhenTearing = 2,
    }

    /// See [`Cursor::no_break_fs_vrr`]
    NoBreakFullscreenVrr {
        /// Disable this behavior.
        Off = 0,

        /// Enable this behavior.
        On = 1,

        /// Automatically enable this behavior for `game` content type.
        #[default]
        AutoGame = 2,
    }

    /// See [`Cursor::warp_on_change_workspace`] and [`Cursor::warp_on_toggle_special`]
    CursorWarp {
        /// Do not warp the cursor.
        #[default]
        Disabled = 0,

        /// Warp the cursor unless blocked by `cursor.no_warps`.
        Enabled = 1,

        /// Warp the cursor, ignoring `cursor.no_warps`.
        Force = 2,
    }

    /// See [`Cursor::use_cpu_buffer`]
    CursorUseCpuBuffer {
        /// Disable CPU buffer usage.
        Off = 0,

        /// Enable CPU buffer usage.
        On = 1,

        /// Automatically enable on Nvidia.
        #[default]
        AutoNvidia = 2,
    }

    /// See [`Quirks::prefer_hdr`]
    PreferHdr {
        /// Do not report HDR mode as preferred.
        #[default]
        Off = 0,

        /// Always report HDR mode as preferred.
        Always = 1,

        /// Report HDR mode as preferred only for gamescope.
        GamescopeOnly = 2,
    }

    /// See [`Debug::damage_tracking`]
    DamageTracking {
        /// Disable damage tracking.
        None = 0,

        /// Track monitor damage.
        Monitor = 1,

        /// Track full damage.
        #[default]
        Full = 2,
    }

    /// See [`Debug::error_position`]
    ErrorPosition {
        /// Show the error bar at the top.
        #[default]
        Top = 0,

        /// Show the error bar at the bottom.
        Bottom = 1,
    }

    /// See [`Debug::invalidate_fp16`]
    InvalidateFp16 {
        /// Do not allow FP16 buffer invalidation.
        NotAllowed = 0,

        /// Allow FP16 buffer invalidation.
        Allowed = 1,

        /// Allow FP16 buffer invalidation except on Nvidia.
        #[default]
        NotAllowedOnNvidia = 2,
    }

    /// See [`Dwindle::force_split`]
    DwindleForceSplit {
        /// Split direction follows the mouse.
        #[default]
        FollowsMouse = 0,

        /// Always split to the left or top.
        AlwaysLeftOrTop = 1,

        /// Always split to the right or bottom.
        AlwaysRightOrBottom = 2,
    }

    /// See [`Dwindle::split_bias`]
    DwindleSplitBias {
        /// The directional window receives the split ratio.
        ///
        /// This is the top or left window.
        #[default]
        Directional = 0,

        /// The current window receives the split ratio.
        CurrentWindow = 1,
    }

    /// See [`Scrolling::focus_fit_method`]
    ScrollingFocusFitMethod {
        /// Center the focused column.
        Center = 0,

        /// Fit the focused column into view.
        #[default]
        Fit = 1,
    }

    FontWeight {
        Thin = 100,
        Ultralight = 200,
        Light = 300,
        Semilight = 350,
        Book = 380,
        #[default]
        Normal = 400,
        Medium = 500,
        Semibold = 600,
        Bold = 700,
        Ultrabold = 800,
        Heavy = 900,
        Ultraheavy = 1000,
    }
}

#[derive(Debug, Clone, Copy, Default)]
pub struct CssGaps {
    pub top: f32,
    pub right: f32,
    pub bottom: f32,
    pub left: f32,
}

impl CssGaps {
    pub fn new(top: f32, right: f32, bottom: f32, left: f32) -> Self {
        Self {
            top,
            right,
            bottom,
            left,
        }
    }

    pub fn same(value: f32) -> Self {
        Self {
            top: value,
            right: value,
            bottom: value,
            left: value,
        }
    }

    pub fn as_same(&self) -> Option<f32> {
        if self.top == self.right && self.top == self.bottom && self.top == self.left {
            Some(self.top)
        } else {
            None
        }
    }
}

impl From<f32> for CssGaps {
    fn from(value: f32) -> Self {
        Self {
            top: value,
            right: value,
            bottom: value,
            left: value,
        }
    }
}

impl From<u32> for CssGaps {
    fn from(value: u32) -> Self {
        Self::from(value as f32)
    }
}

impl From<(f32, f32, f32, f32)> for CssGaps {
    fn from(value: (f32, f32, f32, f32)) -> Self {
        Self {
            top: value.0,
            right: value.1,
            bottom: value.2,
            left: value.3,
        }
    }
}

impl From<(u32, u32, u32, u32)> for CssGaps {
    fn from(value: (u32, u32, u32, u32)) -> Self {
        Self::from((
            value.0 as f32,
            value.1 as f32,
            value.2 as f32,
            value.3 as f32,
        ))
    }
}

impl IntoLua for CssGaps {
    fn into_lua(self, lua: &Lua) -> LuaResult<LuaValue> {
        if let Some(same) = self.as_same() {
            Ok(LuaValue::Number(same as f64))
        } else {
            let table = lua.create_table()?;
            table.set("top", self.top)?;
            table.set("right", self.right)?;
            table.set("bottom", self.bottom)?;
            table.set("left", self.left)?;
            Ok(LuaValue::Table(table))
        }
    }
}

#[derive(Debug, Clone, Copy, Default)]
struct DurationMs(pub u32);

impl From<Duration> for DurationMs {
    fn from(value: Duration) -> Self {
        Self(value.as_millis() as u32)
    }
}

impl IntoLua for DurationMs {
    fn into_lua(self, lua: &Lua) -> LuaResult<LuaValue> {
        self.0.into_lua(lua)
    }
}

#[derive(Debug, Clone, Copy, Default)]
struct DurationSecs(pub f64);

impl From<Duration> for DurationSecs {
    fn from(value: Duration) -> Self {
        Self(value.as_secs_f64())
    }
}

impl IntoLua for DurationSecs {
    fn into_lua(self, lua: &Lua) -> LuaResult<LuaValue> {
        self.0.into_lua(lua)
    }
}
