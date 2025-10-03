class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "1a4a28f79045b87839d3d1de528908577ff95db93dd4e3608de84471b8aa047d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdccbf289bf4cb2411e3163fe4b8d2faac5c5ef078707e11eaca0ccf038b2f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d1131307071d59d9772e33c82f9ca59e410903c4c8705424b05ffcd0ee56a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76138e5d61c2b401b51347702c135e369ef1de8eadab5b9aac3ffa84aa748e2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cabf048b15501311dcb7294a37e42753e05621aaa066e2334e0cdd126a5e46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5edbf39fac894b8ce3a1a5c34d002fd72aae8e4d6fc02a6d28918c394a830cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e8d25b081f4d599e27927d03c8ccc25b2d439db1ce6066c106bce8ff739759"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
