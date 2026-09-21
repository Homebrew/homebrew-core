class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "e5253c2d9a59be9940ec4d9a767395388a9820db839bc1e0ed99a75c07006f83"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "808515a98efb177e69a2d40091a46a07d9087c948068af241410b7db3ca0a96c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "307a9dd2d907bffcafda5fe1985e03af7fa4249e43c0cd8d90cad06132fb0b39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96e691565ad00990b8ff47db3e646572ad9d8985e12fce1b6821a26ff423acda"
    sha256 cellar: :any,                 arm64_linux:       "5900928c8b8ad5d4898b61e07b4cb12c90072e8dd79b1faaa6258f9429bc77e7"
    sha256 cellar: :any,                 x86_64_linux:      "9fadc2832ccd7b71d16fd5c172d66f6f9e68b036c0f1670d55bb8e2f19bcdfab"
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
