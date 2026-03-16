package("glu")

    set_homepage("https://gitlab.freedesktop.org/mesa/glu")
    set_description("OpenGL utility library")

    add_urls("https://archive.mesa3d.org/glu/glu-$(version).tar.xz")
    add_versions("9.0.3", "bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f")

    if is_plat("linux") then
        add_deps("meson", "ninja")
        add_syslinks("GL")
    end

    on_fetch(function (package, opt)
        if package:is_plat("macosx") then
            return {frameworks = "OpenGL", defines = "GL_SILENCE_DEPRECATION"}
        elseif package:is_plat("windows", "mingw") then
            return {links = "glu32"}
        end
        if opt.system then
            if package:is_plat("linux") and package.find_package then
                return package:find_package("glu", opt) or package:find_package("libglu", opt)
            end
        end
    end)

    on_install("linux", function (package)
        local configs = {}
        table.insert(configs, "-Ddefault_library=" .. (package:config("shared") and "shared" or "static"))
        import("package.tools.meson").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cincludes("GL/glu.h"))
    end)
