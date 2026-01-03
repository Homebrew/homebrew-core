class VscodeEslintLanguageServer < Formula
  desc "ESLint language server from VSCode"
  homepage "https://github.com/microsoft/vscode-eslint"
  url "https://github.com/microsoft/vscode-eslint/archive/refs/tags/release/3.0.20.tar.gz"
  sha256 "f002c40e8fbf3186abe65158a206e18970c572e38e1872354ba074e0e2d76ad6"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "ci"
    system "npm", "run", "compile:server"

    libexec.install Dir["*"]

    (bin/"vscode-eslint-language-server").write <<~EOS
      #!/usr/bin/env node
      require('#{libexec}/server/out/eslintServer.js');
    EOS
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"vscode-eslint-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 2
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
