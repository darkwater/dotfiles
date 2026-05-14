pub mod config;
pub mod event;

use mlua::prelude::*;

#[mlua::lua_module]
fn libtestrust(lua: &Lua) -> LuaResult<LuaValue> {
    let config = config::Config::new(lua)?;
    config.general.gaps_in(5)?;
    config.general.gaps_out(20)?;
    config.general.border_size(2)?;
    config.general.resize_on_border(false)?;
    config.general.allow_tearing(false)?;
    config.general.layout("dwindle")?;
    config.decoration.rounding(10)?;
    config.decoration.rounding_power(2.0)?;
    config.decoration.active_opacity(1.0)?;
    config.decoration.inactive_opacity(1.0)?;
    config.animations.enabled(true)?;
    config.dwindle.preserve_split(true)?;
    config.master.new_status("master")?;
    config.scrolling.fullscreen_on_one_column(true)?;
    config.apply()?;

    println!("Hello from Rust!");

    let searchers = lua
        .globals()
        .get::<LuaTable>("package")?
        .get::<LuaTable>("searchers")?;

    for value in searchers.sequence_values::<LuaFunction>() {
        dbg!(value?.info().source);
    }

    Ok(LuaValue::Nil)
}
