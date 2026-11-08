class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "85034cc33a8774441a471ffc49d32658a43a3da8a80deb662207a3b2a34f336f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "63a0d829de4db3eb932d12b40d018d24faed26a4e1326bfe4c991e4de29240eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ba3bc113540a594c2a9b25b84a9cd421681c3036cee8537824371fe6610fc574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22da6f3a4faae0e5b6230d2cf4564cd12ed907a2d1671b6cff1882f15f8acd54"
    sha256 cellar: :any,                 arm64_linux:       "11384913089402e4b72f6cffe6a7f05ebff6ff5298503e4d6d539bbc5c47fa56"
    sha256 cellar: :any,                 x86_64_linux:      "050632363e6d6bd16df1132dcfc48755bded7d80426a6f452514edc47fa263e1"
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
