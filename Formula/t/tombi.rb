class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "3868abbbe9a8acd58ad970d0b038b45d1acf4c13f564583bf683e2eb577ce9d3"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7feebdccf6c2cf123c3f78b559ee8d3b8620188b109680cd331519d208c3fb4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb75dece0cd6b0002a6405045981860521b07e2fe3bc63f1d62f61bd838c49ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9e70b0cdb826f7ad12a1afc8fc66b514f9a1acf7c00e540bdfc414bc131a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c3f023ba5b97d08beabea5c58fd170b259254df35905b0949f531893ab060f"
    sha256 cellar: :any,                 arm64_linux:   "f41bfecdbf33d287c2d489b387fb04019f1a5f9ebda20daec853ef5e20b9c2bc"
    sha256 cellar: :any,                 x86_64_linux:  "e1f78fad7ad0c8176206e1c049ed164eccb7aedb3739e42fcc20f132e155856f"
  end

  depends_on "rust" => :build

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
