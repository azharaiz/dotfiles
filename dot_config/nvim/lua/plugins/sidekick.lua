return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          enabled = true,
          backend = "tmux",
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
  },
}
