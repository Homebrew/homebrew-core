class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "2f547f4adb35b85b01e1a64fea911cdae5e4c3eec4903fa04cb8f05eaf473851"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "203f7aa2c67aa8df5325764bbc37956c32376f43072073faaa8452d1085ce864"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5a03d1edbee0bb96f1af564219dade899b3f3df663614429c27b44269b57b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9d55693bf7844dbc80ca1583f15a4e5d13dbccef5a0b6bfe79871e8a41adfc5"
    sha256 cellar: :any,                 arm64_linux:       "3f69f9d638ca9319767feba5d4fd4c7cb9d97cb3350e4fce27a50192ca929d92"
    sha256 cellar: :any,                 x86_64_linux:      "0764033a4b0c7d6f92eda8121450ce05f0c0c8edb7e55273e20c3c73168d4e8c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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
