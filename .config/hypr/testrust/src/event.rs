macro_rules! parse {
    (
        ---@alias HL.EventName
        $( ---| $event:literal as $name:ident )*
    ) => {
        pub enum EventName {
            $( $name, )*
        }

        impl EventName {
            pub fn as_str(&self) -> &'static str {
                match self {
                    $( Self::$name => $event, )*
                }
            }
        }

        impl core::str::FromStr for EventName {
            type Err = ();

            fn from_str(s: &str) -> Result<Self, Self::Err> {
                match s {
                    $( $event => Ok(Self::$name), )*
                    _ => Err(()),
                }
            }
        }
    };
}

parse! {
    ---@alias HL.EventName
    ---| "config.reloaded" as ConfigReloaded
    ---| "hyprland.shutdown" as HyprlandShutdown
    ---| "hyprland.start" as HyprlandStart
    ---| "keybinds.submap" as KeybindsSubmap
    ---| "layer.closed" as LayerClosed
    ---| "layer.opened" as LayerOpened
    ---| "monitor.added" as MonitorAdded
    ---| "monitor.focused" as MonitorFocused
    ---| "monitor.layout_changed" as MonitorLayoutChanged
    ---| "monitor.removed" as MonitorRemoved
    ---| "screenshare.state" as ScreenshareState
    ---| "window.active" as WindowActive
    ---| "window.class" as WindowClass
    ---| "window.close" as WindowClose
    ---| "window.destroy" as WindowDestroy
    ---| "window.fullscreen" as WindowFullscreen
    ---| "window.kill" as WindowKill
    ---| "window.move_to_workspace" as WindowMoveToWorkspace
    ---| "window.open" as WindowOpen
    ---| "window.open_early" as WindowOpenEarly
    ---| "window.pin" as WindowPin
    ---| "window.title" as WindowTitle
    ---| "window.update_rules" as WindowUpdateRules
    ---| "window.urgent" as WindowUrgent
    ---| "workspace.active" as WorkspaceActive
    ---| "workspace.created" as WorkspaceCreated
    ---| "workspace.move_to_monitor" as WorkspaceMoveToMonitor
    ---| "workspace.removed" as WorkspaceRemoved
}
