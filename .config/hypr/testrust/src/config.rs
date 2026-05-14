use core::time::Duration;

use mlua::prelude::*;

macro_rules! config {
    (
        $(
            // General general {
            $section:ident $section_lower:ident {
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
            $( pub $section_lower: $section, )*
        }

        impl<'a> Config<'a> {
            pub fn new(lua: &'a Lua) -> LuaResult<Self> {
                $( let $section_lower = $section::new(lua)?; )*

                Ok(Self {
                    lua,
                    $( $section_lower, )*
                })
            }

            pub fn apply(&self) -> LuaResult<()> {
                let config_table = self.lua.create_table()?;

                $(
                    config_table.set(stringify!($section_lower), self.$section_lower.table.clone())?;
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
                pub table: LuaTable,
            }

            impl $section {
                pub fn new(lua: &Lua) -> LuaResult<Self> {
                    let table = lua.create_table()?;
                    Ok(Self { table })
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

            impl From<$name> for u32 {
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

// ---@class HL.ConfigValueTypes
// ---@field ['animations.enabled'] boolean
// ---@field ['animations.workspace_wraparound'] boolean
// ---@field ['binds.allow_pin_fullscreen'] boolean
// ---@field ['binds.allow_workspace_cycles'] boolean
// ---@field ['binds.disable_keybind_grabbing'] boolean
// ---@field ['binds.drag_threshold'] integer|boolean
// ---@field ['binds.focus_preferred_method'] integer|boolean
// ---@field ['binds.hide_special_on_workspace_change'] boolean
// ---@field ['binds.ignore_group_lock'] boolean
// ---@field ['binds.movefocus_cycles_fullscreen'] boolean
// ---@field ['binds.movefocus_cycles_groupfirst'] boolean
// ---@field ['binds.pass_mouse_when_bound'] boolean
// ---@field ['binds.scroll_event_delay'] integer|boolean
// ---@field ['binds.window_direction_monitor_fallback'] boolean
// ---@field ['binds.workspace_back_and_forth'] boolean
// ---@field ['binds.workspace_center_on'] integer|boolean
// ---@field ['cursor.default_monitor'] string
// ---@field ['cursor.enable_hyprcursor'] boolean
// ---@field ['cursor.hide_on_key_press'] boolean
// ---@field ['cursor.hide_on_tablet'] boolean
// ---@field ['cursor.hide_on_touch'] boolean
// ---@field ['cursor.hotspot_padding'] integer|boolean
// ---@field ['cursor.inactive_timeout'] number|boolean
// ---@field ['cursor.invisible'] boolean
// ---@field ['cursor.min_refresh_rate'] integer|boolean
// ---@field ['cursor.no_break_fs_vrr'] integer|boolean
// ---@field ['cursor.no_hardware_cursors'] integer|boolean
// ---@field ['cursor.no_warps'] boolean
// ---@field ['cursor.persistent_warps'] boolean
// ---@field ['cursor.sync_gsettings_theme'] boolean
// ---@field ['cursor.use_cpu_buffer'] integer|boolean
// ---@field ['cursor.warp_back_after_non_mouse_input'] boolean
// ---@field ['cursor.warp_on_change_workspace'] integer|boolean
// ---@field ['cursor.warp_on_toggle_special'] integer|boolean
// ---@field ['cursor.zoom_detached_camera'] boolean
// ---@field ['cursor.zoom_disable_aa'] boolean
// ---@field ['cursor.zoom_factor'] number|boolean
// ---@field ['cursor.zoom_rigid'] boolean
// ---@field ['debug.colored_stdout_logs'] boolean
// ---@field ['debug.damage_blink'] boolean
// ---@field ['debug.damage_tracking'] integer|boolean
// ---@field ['debug.disable_logs'] boolean
// ---@field ['debug.disable_scale_checks'] boolean
// ---@field ['debug.disable_time'] boolean
// ---@field ['debug.ds_handle_same_buffer'] boolean
// ---@field ['debug.ds_handle_same_buffer_fifo'] boolean
// ---@field ['debug.enable_stdout_logs'] boolean
// ---@field ['debug.error_limit'] integer|boolean
// ---@field ['debug.error_position'] integer|boolean
// ---@field ['debug.fifo_pending_workaround'] boolean
// ---@field ['debug.full_cm_proto'] boolean
// ---@field ['debug.gl_debugging'] boolean
// ---@field ['debug.invalidate_fp16'] integer|boolean
// ---@field ['debug.log_damage'] boolean
// ---@field ['debug.manual_crash'] integer|boolean
// ---@field ['debug.overlay'] boolean
// ---@field ['debug.pass'] boolean
// ---@field ['debug.render_solitary_wo_damage'] boolean
// ---@field ['debug.suppress_errors'] boolean
// ---@field ['debug.vfr'] boolean
// ---@field ['decoration.active_opacity'] number|boolean
// ---@field ['decoration.blur.brightness'] number|boolean
// ---@field ['decoration.blur.contrast'] number|boolean
// ---@field ['decoration.blur.enabled'] boolean
// ---@field ['decoration.blur.ignore_opacity'] boolean
// ---@field ['decoration.blur.input_methods'] boolean
// ---@field ['decoration.blur.input_methods_ignorealpha'] number|boolean
// ---@field ['decoration.blur.new_optimizations'] boolean
// ---@field ['decoration.blur.noise'] number|boolean
// ---@field ['decoration.blur.passes'] integer|boolean
// ---@field ['decoration.blur.popups'] boolean
// ---@field ['decoration.blur.popups_ignorealpha'] number|boolean
// ---@field ['decoration.blur.size'] integer|boolean
// ---@field ['decoration.blur.special'] boolean
// ---@field ['decoration.blur.vibrancy'] number|boolean
// ---@field ['decoration.blur.vibrancy_darkness'] number|boolean
// ---@field ['decoration.blur.xray'] boolean
// ---@field ['decoration.border_part_of_window'] boolean
// ---@field ['decoration.dim_around'] number|boolean
// ---@field ['decoration.dim_inactive'] boolean
// ---@field ['decoration.dim_modal'] boolean
// ---@field ['decoration.dim_special'] number|boolean
// ---@field ['decoration.dim_strength'] number|boolean
// ---@field ['decoration.fullscreen_opacity'] number|boolean
// ---@field ['decoration.glow.color'] string
// ---@field ['decoration.glow.color_inactive'] string
// ---@field ['decoration.glow.enabled'] boolean
// ---@field ['decoration.glow.range'] integer|boolean
// ---@field ['decoration.glow.render_power'] integer|boolean
// ---@field ['decoration.inactive_opacity'] number|boolean
// ---@field ['decoration.rounding'] integer|boolean
// ---@field ['decoration.rounding_power'] number|boolean
// ---@field ['decoration.screen_shader'] string
// ---@field ['decoration.shadow.color'] string
// ---@field ['decoration.shadow.color_inactive'] string
// ---@field ['decoration.shadow.enabled'] boolean
// ---@field ['decoration.shadow.offset'] HL.Vec2Like
// ---@field ['decoration.shadow.range'] integer|boolean
// ---@field ['decoration.shadow.render_power'] integer|boolean
// ---@field ['decoration.shadow.scale'] number|boolean
// ---@field ['decoration.shadow.sharp'] boolean
// ---@field ['dwindle.default_split_ratio'] number|boolean
// ---@field ['dwindle.force_split'] integer|boolean
// ---@field ['dwindle.permanent_direction_override'] boolean
// ---@field ['dwindle.precise_mouse_move'] boolean
// ---@field ['dwindle.preserve_split'] boolean
// ---@field ['dwindle.smart_resizing'] boolean
// ---@field ['dwindle.smart_split'] boolean
// ---@field ['dwindle.special_scale_factor'] number|boolean
// ---@field ['dwindle.split_bias'] integer|boolean
// ---@field ['dwindle.split_width_multiplier'] number|boolean
// ---@field ['dwindle.use_active_for_splits'] boolean
// ---@field ['ecosystem.enforce_permissions'] boolean
// ---@field ['ecosystem.no_donation_nag'] boolean
// ---@field ['ecosystem.no_update_news'] boolean
// ---@field ['experimental.wp_cm_1_2'] boolean
// ---@field ['general.allow_tearing'] boolean
// ---@field ['general.border_size'] integer|boolean
// ---@field ['general.col.active_border'] string|HL.Gradient
// ---@field ['general.col.inactive_border'] string|HL.Gradient
// ---@field ['general.col.nogroup_border'] string|HL.Gradient
// ---@field ['general.col.nogroup_border_active'] string|HL.Gradient
// ---@field ['general.extend_border_grab_area'] integer|boolean
// ---@field ['general.float_gaps'] integer|HL.CssGap
// ---@field ['general.gaps_in'] integer|HL.CssGap
// ---@field ['general.gaps_out'] integer|HL.CssGap
// ---@field ['general.gaps_workspaces'] integer|boolean
// ---@field ['general.hover_icon_on_border'] boolean
// ---@field ['general.layout'] string
// ---@field ['general.locale'] string
// ---@field ['general.modal_parent_blocking'] boolean
// ---@field ['general.no_focus_fallback'] boolean
// ---@field ['general.resize_corner'] integer|boolean
// ---@field ['general.resize_on_border'] boolean
// ---@field ['general.snap.border_overlap'] boolean
// ---@field ['general.snap.enabled'] boolean
// ---@field ['general.snap.monitor_gap'] integer|boolean
// ---@field ['general.snap.respect_gaps'] boolean
// ---@field ['general.snap.window_gap'] integer|boolean
// ---@field ['gestures.close_max_timeout'] integer|boolean
// ---@field ['gestures.scrolling.move_snap_cursor'] boolean
// ---@field ['gestures.scrolling.move_snap_to_grid'] boolean
// ---@field ['gestures.workspace_swipe_cancel_ratio'] number|boolean
// ---@field ['gestures.workspace_swipe_create_new'] boolean
// ---@field ['gestures.workspace_swipe_direction_lock'] boolean
// ---@field ['gestures.workspace_swipe_direction_lock_threshold'] integer|boolean
// ---@field ['gestures.workspace_swipe_distance'] integer|boolean
// ---@field ['gestures.workspace_swipe_forever'] boolean
// ---@field ['gestures.workspace_swipe_invert'] boolean
// ---@field ['gestures.workspace_swipe_min_speed_to_force'] integer|boolean
// ---@field ['gestures.workspace_swipe_touch'] boolean
// ---@field ['gestures.workspace_swipe_touch_invert'] boolean
// ---@field ['gestures.workspace_swipe_use_r'] boolean
// ---@field ['group.auto_group'] boolean
// ---@field ['group.col.border_active'] string|HL.Gradient
// ---@field ['group.col.border_inactive'] string|HL.Gradient
// ---@field ['group.col.border_locked_active'] string|HL.Gradient
// ---@field ['group.col.border_locked_inactive'] string|HL.Gradient
// ---@field ['group.drag_into_group'] integer|boolean
// ---@field ['group.focus_removed_window'] boolean
// ---@field ['group.group_on_movetoworkspace'] boolean
// ---@field ['group.groupbar.blur'] boolean
// ---@field ['group.groupbar.col.active'] string|HL.Gradient
// ---@field ['group.groupbar.col.inactive'] string|HL.Gradient
// ---@field ['group.groupbar.col.locked_active'] string|HL.Gradient
// ---@field ['group.groupbar.col.locked_inactive'] string|HL.Gradient
// ---@field ['group.groupbar.enabled'] boolean
// ---@field ['group.groupbar.font_family'] string
// ---@field ['group.groupbar.font_size'] integer|boolean
// ---@field ['group.groupbar.font_weight_active'] integer|string
// ---@field ['group.groupbar.font_weight_inactive'] integer|string
// ---@field ['group.groupbar.gaps_in'] integer|boolean
// ---@field ['group.groupbar.gaps_out'] integer|boolean
// ---@field ['group.groupbar.gradient_round_only_edges'] boolean
// ---@field ['group.groupbar.gradient_rounding'] integer|boolean
// ---@field ['group.groupbar.gradient_rounding_power'] number|boolean
// ---@field ['group.groupbar.gradients'] boolean
// ---@field ['group.groupbar.height'] integer|boolean
// ---@field ['group.groupbar.indicator_gap'] integer|boolean
// ---@field ['group.groupbar.indicator_height'] integer|boolean
// ---@field ['group.groupbar.keep_upper_gap'] boolean
// ---@field ['group.groupbar.middle_click_close'] boolean
// ---@field ['group.groupbar.priority'] integer|boolean
// ---@field ['group.groupbar.render_titles'] boolean
// ---@field ['group.groupbar.round_only_edges'] boolean
// ---@field ['group.groupbar.rounding'] integer|boolean
// ---@field ['group.groupbar.rounding_power'] number|boolean
// ---@field ['group.groupbar.scrolling'] boolean
// ---@field ['group.groupbar.stacked'] boolean
// ---@field ['group.groupbar.text_color'] string
// ---@field ['group.groupbar.text_color_inactive'] string
// ---@field ['group.groupbar.text_color_locked_active'] string
// ---@field ['group.groupbar.text_color_locked_inactive'] string
// ---@field ['group.groupbar.text_offset'] integer|boolean
// ---@field ['group.groupbar.text_padding'] integer|boolean
// ---@field ['group.insert_after_current'] boolean
// ---@field ['group.merge_floated_into_tiled_on_groupbar'] boolean
// ---@field ['group.merge_groups_on_drag'] boolean
// ---@field ['group.merge_groups_on_groupbar'] boolean
// ---@field ['input.accel_profile'] string
// ---@field ['input.emulate_discrete_scroll'] integer|boolean
// ---@field ['input.float_switch_override_focus'] integer|boolean
// ---@field ['input.focus_on_close'] integer|boolean
// ---@field ['input.follow_mouse'] integer|boolean
// ---@field ['input.follow_mouse_shrink'] integer|boolean
// ---@field ['input.follow_mouse_threshold'] number|boolean
// ---@field ['input.force_no_accel'] boolean
// ---@field ['input.kb_file'] string
// ---@field ['input.kb_layout'] string
// ---@field ['input.kb_model'] string
// ---@field ['input.kb_options'] string
// ---@field ['input.kb_rules'] string
// ---@field ['input.kb_variant'] string
// ---@field ['input.left_handed'] boolean
// ---@field ['input.mouse_refocus'] boolean
// ---@field ['input.natural_scroll'] boolean
// ---@field ['input.numlock_by_default'] boolean
// ---@field ['input.off_window_axis_events'] integer|boolean
// ---@field ['input.repeat_delay'] integer|boolean
// ---@field ['input.repeat_rate'] integer|boolean
// ---@field ['input.resolve_binds_by_sym'] boolean
// ---@field ['input.rotation'] integer|boolean
// ---@field ['input.scroll_button'] integer|boolean
// ---@field ['input.scroll_button_lock'] boolean
// ---@field ['input.scroll_factor'] number|boolean
// ---@field ['input.scroll_method'] string
// ---@field ['input.scroll_points'] string
// ---@field ['input.sensitivity'] number|boolean
// ---@field ['input.special_fallthrough'] boolean
// ---@field ['input.tablet.absolute_region_position'] boolean
// ---@field ['input.tablet.active_area_position'] HL.Vec2Like
// ---@field ['input.tablet.active_area_size'] HL.Vec2Like
// ---@field ['input.tablet.left_handed'] boolean
// ---@field ['input.tablet.output'] string
// ---@field ['input.tablet.region_position'] HL.Vec2Like
// ---@field ['input.tablet.region_size'] HL.Vec2Like
// ---@field ['input.tablet.relative_input'] boolean
// ---@field ['input.tablet.transform'] integer|boolean
// ---@field ['input.touchdevice.enabled'] boolean
// ---@field ['input.touchdevice.output'] string
// ---@field ['input.touchdevice.transform'] integer|boolean
// ---@field ['input.touchpad.clickfinger_behavior'] boolean
// ---@field ['input.touchpad.disable_while_typing'] boolean
// ---@field ['input.touchpad.drag_3fg'] integer|boolean
// ---@field ['input.touchpad.drag_lock'] integer|boolean
// ---@field ['input.touchpad.flip_x'] boolean
// ---@field ['input.touchpad.flip_y'] boolean
// ---@field ['input.touchpad.middle_button_emulation'] boolean
// ---@field ['input.touchpad.natural_scroll'] boolean
// ---@field ['input.touchpad.scroll_factor'] number|boolean
// ---@field ['input.touchpad.tap_and_drag'] boolean
// ---@field ['input.touchpad.tap_button_map'] string
// ---@field ['input.touchpad.tap_to_click'] boolean
// ---@field ['input.virtualkeyboard.release_pressed_on_close'] boolean
// ---@field ['input.virtualkeyboard.share_states'] integer|boolean
// ---@field ['layout.single_window_aspect_ratio'] HL.Vec2Like
// ---@field ['layout.single_window_aspect_ratio_tolerance'] number|boolean
// ---@field ['master.allow_small_split'] boolean
// ---@field ['master.always_keep_position'] boolean
// ---@field ['master.center_ignores_reserved'] boolean
// ---@field ['master.center_master_fallback'] string
// ---@field ['master.drop_at_cursor'] boolean
// ---@field ['master.mfact'] number|boolean
// ---@field ['master.new_on_active'] string
// ---@field ['master.new_on_top'] boolean
// ---@field ['master.new_status'] string
// ---@field ['master.orientation'] string
// ---@field ['master.slave_count_for_center_master'] integer|boolean
// ---@field ['master.smart_resizing'] boolean
// ---@field ['master.special_scale_factor'] number|boolean
// ---@field ['misc.allow_session_lock_restore'] boolean
// ---@field ['misc.always_follow_on_dnd'] boolean
// ---@field ['misc.animate_manual_resizes'] boolean
// ---@field ['misc.animate_mouse_windowdragging'] boolean
// ---@field ['misc.anr_missed_pings'] integer|boolean
// ---@field ['misc.background_color'] string
// ---@field ['misc.close_special_on_empty'] boolean
// ---@field ['misc.col.splash'] string
// ---@field ['misc.disable_autoreload'] boolean
// ---@field ['misc.disable_hyprland_guiutils_check'] boolean
// ---@field ['misc.disable_hyprland_logo'] boolean
// ---@field ['misc.disable_scale_notification'] boolean
// ---@field ['misc.disable_splash_rendering'] boolean
// ---@field ['misc.disable_watchdog_warning'] boolean
// ---@field ['misc.disable_xdg_env_checks'] boolean
// ---@field ['misc.enable_anr_dialog'] boolean
// ---@field ['misc.enable_swallow'] boolean
// ---@field ['misc.exit_window_retains_fullscreen'] boolean
// ---@field ['misc.focus_on_activate'] boolean
// ---@field ['misc.font_family'] string
// ---@field ['misc.force_default_wallpaper'] integer|boolean
// ---@field ['misc.initial_workspace_tracking'] integer|boolean
// ---@field ['misc.key_press_enables_dpms'] boolean
// ---@field ['misc.layers_hog_keyboard_focus'] boolean
// ---@field ['misc.lockdead_screen_delay'] integer|boolean
// ---@field ['misc.middle_click_paste'] boolean
// ---@field ['misc.mouse_move_enables_dpms'] boolean
// ---@field ['misc.mouse_move_focuses_monitor'] boolean
// ---@field ['misc.name_vk_after_proc'] boolean
// ---@field ['misc.on_focus_under_fullscreen'] integer|boolean
// ---@field ['misc.render_unfocused_fps'] integer|boolean
// ---@field ['misc.screencopy_force_8b'] boolean
// ---@field ['misc.session_lock_xray'] boolean
// ---@field ['misc.size_limits_tiled'] boolean
// ---@field ['misc.splash_font_family'] string
// ---@field ['misc.swallow_exception_regex'] string
// ---@field ['misc.swallow_regex'] string
// ---@field ['misc.vrr'] integer|boolean
// ---@field ['opengl.nvidia_anti_flicker'] boolean
// ---@field ['quirks.prefer_hdr'] integer|boolean
// ---@field ['quirks.skip_non_kms_dmabuf_formats'] boolean
// ---@field ['render.cm_auto_hdr'] integer|boolean
// ---@field ['render.cm_enabled'] boolean
// ---@field ['render.cm_sdr_eotf'] string
// ---@field ['render.commit_timing_enabled'] boolean
// ---@field ['render.ctm_animation'] integer|boolean
// ---@field ['render.direct_scanout'] integer|boolean
// ---@field ['render.expand_undersized_textures'] boolean
// ---@field ['render.fp16_sdr_tf'] integer|boolean
// ---@field ['render.icc_vcgt_enabled'] boolean
// ---@field ['render.keep_unmodified_copy'] integer|boolean
// ---@field ['render.new_render_scheduling'] boolean
// ---@field ['render.non_shader_cm'] integer|boolean
// ---@field ['render.non_shader_cm_interop'] integer|boolean
// ---@field ['render.send_content_type'] boolean
// ---@field ['render.use_fp16'] integer|boolean
// ---@field ['render.use_shader_blur_blend'] boolean
// ---@field ['render.xp_mode'] boolean
// ---@field ['scrolling.column_width'] number|boolean
// ---@field ['scrolling.direction'] string
// ---@field ['scrolling.explicit_column_widths'] string
// ---@field ['scrolling.focus_fit_method'] integer|boolean
// ---@field ['scrolling.follow_focus'] boolean
// ---@field ['scrolling.follow_min_visible'] number|boolean
// ---@field ['scrolling.fullscreen_on_one_column'] boolean
// ---@field ['scrolling.wrap_focus'] boolean
// ---@field ['scrolling.wrap_swapcol'] boolean
// ---@field ['xwayland.create_abstract_socket'] boolean
// ---@field ['xwayland.enabled'] boolean
// ---@field ['xwayland.force_zero_scaling'] boolean
// ---@field ['xwayland.use_nearest_neighbor'] boolean

config! {
    // border_size	size of the border around windows	int	1
    // gaps_in	gaps between windows	css_gaps	5
    // gaps_out	gaps between windows and monitor edges	css_gaps	20
    // float_gaps	gaps between windows and monitor edges for floating windows -1 means default	css_gaps	0
    // gaps_workspaces	gaps between workspaces. Stacks with gaps_out.	css_gaps	0
    // col.inactive_border	border color for inactive windows	gradient	0xff444444
    // col.active_border	border color for the active window	gradient	0xffffffff
    // col.nogroup_border	inactive border color for window that cannot be added to a group (see hl.dsp.window.deny_from_group dispatcher)	gradient	0xffffaaff
    // col.nogroup_border_active	active border color for window that cannot be added to a group	gradient	0xffff00ff
    // layout	which layout to use. [dwindle/master/scrolling/monocle]	str	dwindle
    // no_focus_fallback	if true, will not fall back to the next available window when moving focus in a direction where no window was found	bool	false
    // resize_on_border	enables resizing windows by clicking and dragging on borders and gaps	bool	false
    // extend_border_grab_area	extends the area around the border where you can click and drag on, only used when general:resize_on_border is on.	int	15
    // hover_icon_on_border	show a cursor icon when hovering over borders, only used when general:resize_on_border is on.	bool	true
    // allow_tearing	master switch for allowing tearing to occur. See the Tearing page.	bool	false
    // resize_corner	force floating windows to use a specific corner when being resized (1-4 going clockwise from top left, 0 to disable)	int	0
    // modal_parent_blocking	whether parent windows of modals will be interactive	bool	true
    // locale	overrides the system locale (e.g. en_US, es)	str	[[Empty]]
    General general {
        /// The size of the border around windows, in pixels.
        ///
        /// Default: `1`
        border_size: u32 => u32,

        /// The gaps between windows, in pixels. Can be set to a single number or a table of
        /// numbers for different gaps on each side.
        ///
        /// Default: `5`
        gaps_in: impl Into<CssGaps> => CssGaps,

        /// The gaps between windows and monitor edges, in pixels. Can be set to a single number
        /// or a table of numbers for different gaps on each side.
        ///
        /// Default: `20`
        gaps_out: impl Into<CssGaps> => CssGaps,

        /// Gaps between windows and monitor edges for floating windows, in pixels.
        ///
        /// Default: `0`
        float_gaps: impl Into<CssGaps> => CssGaps,

        /// Gaps between workspaces. Stacks with `gaps_out`.
        ///
        /// Default: `0`
        gaps_workspaces: impl Into<CssGaps> => CssGaps,

        /// Border color for inactive windows. Can be a solid color or a gradient.
        ///
        /// Default: `0xff444444`
        col_inactive_border: impl Into<LuaValue> => LuaValue,
    }
    Animations animations {
        /// Enable animations
        ///
        /// Default: `true`
        enabled: bool => bool,

        /// Enable workspace wraparound, causing directional workspace animations to animate as if
        /// the first and last workspaces were adjacent
        ///
        /// Default: `false`
        workspace_wraparound: bool => bool,
    }
    Binds binds {
        /// If disabled, will not pass the mouse events to apps / dragging windows around if a
        /// keybind has been triggered.
        ///
        /// Default: `true`
        pass_mouse_when_bound: bool => bool,

        /// How long to wait after a scroll event to allow passing another one for the binds.
        ///
        /// Default: `300ms`
        scroll_event_delay: Duration => DurationMs,

        /// If enabled, an attempt to switch to the currently focused workspace will instead switch
        /// to the previous workspace. Akin to i3’s `auto_back_and_forth`.
        ///
        /// Default: `false`
        workspace_back_and_forth: bool => bool,

        /// If enabled, changing the active workspace (including to itself) will hide the special
        /// workspace on the monitor where the newly active workspace resides.
        ///
        /// Default: `false`
        hide_special_on_workspace_change: bool => bool,

        /// If enabled, workspaces don’t forget their previous workspace, so cycles can be created
        /// by switching to the first workspace in a sequence, then endlessly going to the previous
        /// workspace.
        ///
        /// Default: `false`
        allow_workspace_cycles: bool => bool,

        /// Whether switching workspaces should center the cursor on the workspace or on the last
        /// active window for that workspace.
        ///
        /// Default: [`WorkspaceCenterOn::Workspace`]
        workspace_center_on: WorkspaceCenterOn => u32,

        /// Sets the preferred focus finding method when using focuswindow/movewindow/etc with a
        /// direction.
        ///
        /// Default: [`FocusPreferredMethod::History`]
        focus_preferred_method: FocusPreferredMethod => u32,

        // TODO: refer to the Rust methods in these docs
        /// If enabled, dispatchers like `hl.dsp.window.move({ into_group })` and
        /// `hl.dsp.window.move({ out_of_group })` will ignore lock per group.
        ///
        /// Default: `false`
        ignore_group_lock: bool => bool,

        /// If enabled, when on a fullscreen window, `hl.dsp.focus({ direction })` will cycle
        /// fullscreen, if not, it will move the focus in a direction.
        ///
        /// Default: `false`
        movefocus_cycles_fullscreen: bool => bool,

        /// If enabled, when in a grouped window, `hl.dsp.focus({ direction })` will cycle windows
        /// in the groups first, then at each ends of tabs, it’ll move on to other windows/groups.
        ///
        /// Default: `false`
        movefocus_cycles_groupfirst: bool => bool,

        /// If enabled, moving a window or focus over the edge of a monitor with a direction will
        /// move it to the next monitor in that direction.
        ///
        /// Default: `true`
        window_direction_monitor_fallback: bool => bool,

        /// If enabled, apps that request keybinds to be disabled (e.g. VMs) will not be able to do
        /// so.
        ///
        /// Default: `false`
        disable_keybind_grabbing: bool => bool,

        /// If enabled, Allow fullscreen to pinned windows, and restore their pinned status
        /// afterwards
        ///
        /// Default: `false`
        allow_pin_fullscreen: bool => bool,

        /// Movement threshold in pixels for window dragging and c/g bind flags. 0 to disable and
        /// grab on mousedown.
        ///
        /// Default: `0`
        // TODO: use Option?
        drag_threshold: u32 => u32,
    }
}

enums! {
    /// See [`Binds::workspace_center_on`]
    WorkspaceCenterOn {
        /// Center the cursor on the workspace
        #[default]
        Workspace = 0,
        /// Center the cursor on the last active window for that workspace
        LastActiveWindow = 1,
    }

    /// See [`Binds::focus_preferred_method`]
    FocusPreferredMethod {
        /// Recent windows have priority
        #[default]
        History = 0,
        /// Windows with longer shared edges have priority
        Length = 1,
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
