local lsp = require("lspconfig")

local null_ls = require('null-ls')
-- local jira = require("config.jira")
null_ls.setup {
    sources = {
        -- jira.completion,
        -- jira.hover,
        -- jira.actions,
        -- null_ls.builtins.formatting.swift_format
    },
}

require("pest-vim").setup {}

require("lsp_lines").setup {}
vim.diagnostic.config {
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
    severity_sort = true,
    float = { source = "if_many" },
}

lsp.qmlls.setup {
    cmd = { "qmlls6" },
}

lsp.ts_ls.setup {}

lsp.wgsl_analyzer.setup {
    settings = {
        ["wgsl-analyzer"] = {
            inlayHints = {
                enabled = true,
                typeHints = true,
            },
            customImports = {
                ["bevy_core_pipeline::fullscreen_vertex_shader"] = "file:///home/dark/downloads/bevy/crates/bevy_core_pipeline/src/fullscreen_vertex_shader/fullscreen.wgsl",
                ["bevy_core_pipeline::oit"] = "file:///home/dark/downloads/bevy/crates/bevy_core_pipeline/src/oit/oit_draw.wgsl",
                ["bevy_core_pipeline::post_processing::chromatic_aberration"] = "file:///home/dark/downloads/bevy/crates/bevy_core_pipeline/src/post_process/chromatic_aberration.wgsl",
                ["bevy_core_pipeline::tonemapping_lut_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_core_pipeline/src/tonemapping/lut_bindings.wgsl",
                ["bevy_core_pipeline::tonemapping"] = "file:///home/dark/downloads/bevy/crates/bevy_core_pipeline/src/tonemapping/tonemapping_shared.wgsl",
                ["bevy_pbr::pbr_deferred_functions"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/deferred/pbr_deferred_functions.wgsl",
                ["bevy_pbr::pbr_deferred_types"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/deferred/pbr_deferred_types.wgsl",
                ["bevy_pbr::environment_map"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/light_probe/environment_map.wgsl",
                ["bevy_pbr::irradiance_volume"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/light_probe/irradiance_volume.wgsl",
                ["bevy_pbr::light_probe"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/light_probe/light_probe.wgsl",
                ["bevy_pbr::lightmap"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/lightmap/lightmap.wgsl",
                ["bevy_pbr::meshlet_visibility_buffer_resolve"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/meshlet/dummy_visibility_buffer_resolve.wgsl",
                ["bevy_pbr::meshlet_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/meshlet/meshlet_bindings.wgsl",
                ["bevy_pbr::meshlet_visibility_buffer_resolve"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/meshlet/visibility_buffer_resolve.wgsl",
                ["bevy_pbr::prepass_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/prepass/prepass_bindings.wgsl",
                ["bevy_pbr::prepass_io"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/prepass/prepass_io.wgsl",
                ["bevy_pbr::prepass_utils"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/prepass/prepass_utils.wgsl",
                ["bevy_pbr::clustered_forward"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/clustered_forward.wgsl",
                ["bevy_pbr::fog"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/fog.wgsl",
                ["bevy_pbr::forward_io"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/forward_io.wgsl",
                ["bevy_pbr::mesh_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/mesh_bindings.wgsl",
                ["bevy_pbr::mesh_functions"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/mesh_functions.wgsl",
                ["bevy_pbr::mesh_types"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/mesh_types.wgsl",
                ["bevy_pbr::mesh_view_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/mesh_view_bindings.wgsl",
                ["bevy_pbr::mesh_view_types"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/mesh_view_types.wgsl",
                ["bevy_pbr::morph"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/morph.wgsl",
                ["bevy_pbr::parallax_mapping"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/parallax_mapping.wgsl",
                ["bevy_pbr::ambient"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_ambient.wgsl",
                ["bevy_pbr::pbr_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_bindings.wgsl",
                ["bevy_pbr::pbr_fragment"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_fragment.wgsl",
                ["bevy_pbr::pbr_functions"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_functions.wgsl",
                ["bevy_pbr::lighting"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_lighting.wgsl",
                ["bevy_pbr::pbr_prepass_functions"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_prepass_functions.wgsl",
                ["bevy_pbr::transmission"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_transmission.wgsl",
                ["bevy_pbr::pbr_types"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/pbr_types.wgsl",
                ["bevy_pbr::rgb9e5"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/rgb9e5.wgsl",
                ["bevy_pbr::shadow_sampling"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/shadow_sampling.wgsl",
                ["bevy_pbr::shadows"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/shadows.wgsl",
                ["bevy_pbr::skinning"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/skinning.wgsl",
                ["bevy_pbr::utils"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/utils.wgsl",
                ["bevy_pbr::view_transformations"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/render/view_transformations.wgsl",
                ["bevy_pbr::ssao_utils"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/ssao/ssao_utils.wgsl",
                ["bevy_pbr::raymarch"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/ssr/raymarch.wgsl",
                ["bevy_pbr::ssr"] = "file:///home/dark/downloads/bevy/crates/bevy_pbr/src/ssr/ssr.wgsl",
                ["bevy_render::color_operations"] = "file:///home/dark/downloads/bevy/crates/bevy_render/src/color_operations.wgsl",
                ["bevy_render::globals"] = "file:///home/dark/downloads/bevy/crates/bevy_render/src/globals.wgsl",
                ["bevy_render::maths"] = "file:///home/dark/downloads/bevy/crates/bevy_render/src/maths.wgsl",
                ["bevy_render::view"] = "file:///home/dark/downloads/bevy/crates/bevy_render/src/view/view.wgsl",
                ["bevy_sprite::mesh2d_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_bindings.wgsl",
                ["bevy_sprite::mesh2d_functions"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_functions.wgsl",
                ["bevy_sprite::mesh2d_types"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_types.wgsl",
                ["bevy_sprite::mesh2d_vertex_output"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_vertex_output.wgsl",
                ["bevy_sprite::mesh2d_view_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_view_bindings.wgsl",
                ["bevy_sprite::mesh2d_view_types"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/mesh2d/mesh2d_view_types.wgsl",
                ["bevy_sprite::sprite_view_bindings"] = "file:///home/dark/downloads/bevy/crates/bevy_sprite/src/render/sprite_view_bindings.wgsl",
                ["bevy_ui::ui_vertex_output"] = "file:///home/dark/downloads/bevy/crates/bevy_ui/src/render/ui_vertex_output.wgsl",
            }
        }
    }
}

-- lsp.clangd.setup {}

-- lsp.denols.setup {
--     root_dir = lsp.util.root_pattern("deno.json"),
-- }

-- lsp.slint_lsp.setup {}
-- vim.cmd [[ autocmd BufRead,BufNewFile *.slint set filetype=slint ]]
