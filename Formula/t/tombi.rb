class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "eade922c86cad61a7c418f07a82791ce471a1be93e3421c105d2c9dfcbf1d08e"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    manifest_sha256 "d46a492752ac1459ad506340ea8427a3fc21a3f4f63c3eefc7630d39b39b9a1d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e79b7541b1fc978fc464f750feba347cca61bd4433eea45efb3c347ac4cd99fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b9fc47afc7e904e6228e224ec149dc00c1424a5428bf74d209d6a09eb4d3596"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5daf4a0a78ac44859609fb475554157d5efe4469b0dc3d808b817b645bc3b0a"
    sha256 cellar: :any,                 arm64_linux:       "437c4ff4a0da6905ea0b692fdc04f4c4b927f3b734773f2fafac8667d1ae9d44"
    sha256 cellar: :any,                 x86_64_linux:      "f720693f80e5106533ee86f35d89d4679b6aab6b52c85500113bb067222033c5"
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
