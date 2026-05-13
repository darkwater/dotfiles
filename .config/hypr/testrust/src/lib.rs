pub mod config;
pub mod event;

use mlua::prelude::*;

#[mlua::lua_module]
fn libtestrust(lua: &Lua) -> LuaResult<LuaTable> {
    let config = config::Config::new(lua)?;
    config.general.gaps_in(1.)?;
    config.general.gaps_out(50)?;
    config.apply()?;

    // let ret = lua
    //     .globals()
    //     .get::<LuaTable>("hl")?
    //     .get::<LuaFunction>("bind")?
    //     .call::<LuaValue>((
    //         "ALT + SHIFT + T",
    //         lua.create_async_function(async |lua, ()| {
    //             for n in 1..=3 {
    //                 let args = lua.create_table().unwrap();
    //                 args.set("text", format!("Test bind {n}")).unwrap();
    //                 args.set("timeout", 10000).unwrap();
    //
    //                 lua.globals()
    //                     .get::<LuaTable>("hl")
    //                     .unwrap()
    //                     .get::<LuaTable>("notification")
    //                     .unwrap()
    //                     .get::<LuaFunction>("create")
    //                     .unwrap()
    //                     .call::<()>(args)
    //                     .unwrap();
    //             }
    //
    //             Ok(())
    //         }),
    //     ))?;

    // dbg!(ret);

    println!("Hello from Rust!");

    let searchers = lua
        .globals()
        .get::<LuaTable>("package")?
        .get::<LuaTable>("searchers")?;

    for value in searchers.sequence_values::<LuaValue>() {
        dbg!(value?);
    }

    lua.create_table()
}
