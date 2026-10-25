class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "f2a0969f08d7ea4aa6015df17eaa1f8bebcdf948bea3d68f2fc70ef5f934f631"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7519eba16d184e207d23abe02fac84490b717c2c4c507d19cebf826a943d2ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fab3cbbb60c29b8788d7de6c91592d2a6c8b1d1fdd9899909299902843766ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fd4c4326dca14e00ff683d8c72204cc51012b4579a966f88d27d48729850883"
    sha256 cellar: :any,                 arm64_linux:       "162117fe045116cecfb2bbc8cf9fe2d7fa07fe78ef31a10344f6a06621765ed1"
    sha256 cellar: :any,                 x86_64_linux:      "af51aafa25f5db48485ae97e863627bfdf7a117b64c30d1c397c2fe73d0b6a37"
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
