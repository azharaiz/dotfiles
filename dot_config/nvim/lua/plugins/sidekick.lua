return {
  {
    "folke/sidekick.nvim",
    enabled = false, -- temporarily disabled; re-enable here AND re-add ai.sidekick extra in lazyvim.json
    opts = {
      cli = {
        tools = {
          omp = {
            cmd = { "omp" },
            is_proc = "\\<omp\\>",
            url = "https://github.com/can1357/oh-my-pi",
          },
        },
        win = {
          layout = "float",
          float = {
            width = 0.9,
            height = 0.9,
          },
        },
      },
    },
    -- Same bindings as the LazyVim extra, but tool pickers only list installed tools
    keys = {
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus({ filter = { installed = true } })
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ filter = { installed = true } })
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select CLI",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}", filter = { installed = true } })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}", filter = { installed = true } })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}", filter = { installed = true } })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt(function(_, text)
            if text then
              require("sidekick.cli").send({ text = text, filter = { installed = true } })
            end
          end)
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}
