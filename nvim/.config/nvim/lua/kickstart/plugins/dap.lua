return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
    },
    event = 'VeryLazy',
    config = function()
      require('dap-go').setup()
    end,
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'toggle [d]ebug [b]reakpoint',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = '[d]ebug [B]reakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = '[d]ebug [c]ontinue (start here)',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = '[d]ebug [C]ursor',
      },
      {
        '<leader>dg',
        function()
          require('dap').goto_()
        end,
        desc = '[d]ebug [g]o to line',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = '[d]ebug step [o]ver',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = '[d]ebug step [O]ut',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[d]ebug [i]nto',
      },
      {
        '<leader>dj',
        function()
          require('dap').down()
        end,
        desc = '[d]ebug [j]ump down',
      },
      {
        '<leader>dk',
        function()
          require('dap').up()
        end,
        desc = '[d]ebug [k]ump up',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = '[d]ebug [l]ast',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = '[d]ebug [p]ause',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = '[d]ebug [r]epl',
      },
      {
        '<leader>dR',
        function()
          require('dap').clear_breakpoints()
        end,
        desc = '[d]ebug [R]emove breakpoints',
      },
      {
        '<leader>ds',
        function()
          require('dap').session()
        end,
        desc = '[d]ebug [s]ession',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = '[d]ebug [t]erminate',
      },
      {
        '<leader>dw',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = '[d]ebug [w]idgets',
      },
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    opts = {},
    config = function()
      -- setup dap config by VsCode launch.json file
      require('dap.ext.vscode').load_launchjs()
      local dap, dapui = require 'dap', require 'dapui'

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = '[d]ap [u]i',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval()
        end,
        desc = '[d]ap [e]val',
      },
    },
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = {},
  },
}
