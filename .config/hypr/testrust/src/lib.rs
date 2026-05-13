use mlua::prelude::*;

#[mlua::lua_module]
fn libtestrust(lua: &Lua) -> LuaResult<LuaTable> {
    let config = config::Config::new(lua)?;
    config.general.gaps_in(1.)?;
    config.general.gaps_out(50.)?;
    config.apply()?;

    let ret = lua
        .globals()
        .get::<LuaTable>("hl")?
        .get::<LuaFunction>("bind")?
        .call::<LuaValue>((
            "ALT + SHIFT + T",
            lua.create_async_function(async |lua, ()| {
                for n in 1..=3 {
                    let args = lua.create_table().unwrap();
                    args.set("text", format!("Test bind {n}")).unwrap();
                    args.set("timeout", 10000).unwrap();

                    lua.globals()
                        .get::<LuaTable>("hl")
                        .unwrap()
                        .get::<LuaTable>("notification")
                        .unwrap()
                        .get::<LuaFunction>("create")
                        .unwrap()
                        .call::<()>(args)
                        .unwrap();
                }

                Ok(())
            }),
        ))?;

    dbg!(ret);

    println!("Hello from Rust!");

    lua.create_table()
}

pub mod config {
    use mlua::prelude::*;

    pub struct Config<'a> {
        lua: &'a Lua,
        pub general: General,
    }

    impl<'a> Config<'a> {
        pub fn new(lua: &'a Lua) -> LuaResult<Self> {
            let general = General::new(lua)?;
            Ok(Self { lua, general })
        }

        pub fn apply(&self) -> LuaResult<()> {
            let config_table = self.lua.create_table()?;
            config_table.set("general", self.general.table.clone())?;

            self.lua
                .globals()
                .get::<LuaTable>("hl")?
                .get::<LuaFunction>("config")?
                .call::<()>(config_table)?;

            Ok(())
        }
    }

    pub struct General {
        pub table: LuaTable,
    }

    impl General {
        pub fn new(lua: &Lua) -> LuaResult<Self> {
            let table = lua.create_table()?;
            Ok(Self { table })
        }

        pub fn gaps_in(&self, gaps: f32) -> LuaResult<()> {
            self.table.set("gaps_in", gaps)?;
            Ok(())
        }

        pub fn gaps_out(&self, gaps: f32) -> LuaResult<()> {
            self.table.set("gaps_out", gaps)?;
            Ok(())
        }
    }
}
