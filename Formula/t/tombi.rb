class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.9.tar.gz"
  sha256 "70c99a49437e1778b30909a3567a113cd4d01af998f22d82207a673f480313d0"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef62361b7d88fdc38eabd4ab98afc2229b3ead268e4be10b2497397d5d177bd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f12b3138fc14029c8c736a2c11091b2a8964514baa4a2c0392701fc699ea425"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7c837c2ad22d4804bdc9c6526ac319c5443dab4be703c843785f1cda559d9d1"
    sha256 cellar: :any,                 arm64_linux:       "30cbbda232836cb9ac190f7812d065f8f72429a18569309251acf4cb2000d822"
    sha256 cellar: :any,                 x86_64_linux:      "56b59afaef1f56a066e2804082dbdf1ce98142ccbb57151ca70254187a7e1994"
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
