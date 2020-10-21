if ENV["TMPSETS"] && ENV["COVERAGE"] != "false"
  SimpleCov.start do
    def add_mod_group modname
      puts "add_mod_group #{modname}"
      mod_dir = /(card-mod-)?#{Regexp.escape modname}/
      add_group "Mod: #{modname}", %r{(mod/|/tmp.*/.*/mod\d{3}-)#{mod_dir}}
    end

    Dir["mod/*"].each do |path|
      modname = path.gsub "mod/", ""
      add_mod_group modname
    end

    Dir["vendor/card-mods/card-mod-*"].each do |path|
      match = path.match /card-mod-(?<modname>.*)$/
      add_mod_group match[:modname]
    end

    add_filter "/spec/"
    add_filter "/features/"
    add_filter "/config/"
    add_filter "/tasks/"
  end
end
