class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "a78a88a31af80ee5ce0db75c7a589106f64b314bfff16ef8ac490d414e7de567"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "df0ea6e490277244dc80a91476ef0952b827bb8dd24e877a90ea6eb220219139"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12a0f42c2ab642b0de7a61ff9f0d886ccee4dfad4c251fc011669ff8a460c7c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f716fe1486a88c7e6b9a6e05c26d11a26df4860b17f7aafb45f11df137f4872b"
    sha256 cellar: :any,                 arm64_linux:       "477fdef2fdff36529a0bc72ed8c23fbc1964b3c074ab309b41e84d901eb051f9"
    sha256 cellar: :any,                 x86_64_linux:      "ab28a177a3e50eccf9843f17e8b8c7c970f9c4c1d59ce96bc22c4b281dcfb9d2"
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
