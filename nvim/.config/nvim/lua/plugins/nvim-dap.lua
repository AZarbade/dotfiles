return {
  {
    "mfussenegger/nvim-dap",
    event = "BufRead",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Breakpoint",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "UI",
      },
      {
        "<leader>dx",
        function()
          require("dap").terminate()
        end,
        desc = "Exit",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local virtual_text = require("nvim-dap-virtual-text")

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/usr/bin/codelldb-x86_64-linux/extension/adapter/codelldb", -- adjust as needed, must be absolute path
          args = { "--port", "${port}" },
        },
      }

      local codelldb = {
        name = "Launch codelldb",
        type = "codelldb", -- matches the adapter
        request = "launch", -- could also attach to a currently running process
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      }

      dap.configurations.c = {
        codelldb,
      }
      dap.configurations.cpp = dap.configurations.c

      dapui.setup()
      virtual_text.setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = nil,
    },
  },
}
