---@diagnostic disable: undefined-global -- jjui injects: context, flash, exec_shell

function setup(config)
  -- register actions and bindings here

    config.action("show diff in diffnav", function()
      local change_id = context.change_id()
      if not change_id or change_id == "" then
        flash({ text = "No revision selected", error = true })
        return
      end

      exec_shell(string.format("jj diff -r %q --git --color never | zed -", change_id))
    end, { desc = "show diff in diffnav", key = "alt+d", scope = "revisions" })

end
