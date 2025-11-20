class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.52.tar.gz"
  sha256 "7a9d1143146e20b7c2581edd6df596af93a01b10410710e4893dd2bb0bdb54a6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d329ec119badfb26256657fb9704c1a8d4fa70882427b082818e8d2b34f11a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82bfac2e07afc7bbb24288d9326d6c5eef1803da0017a8a1ea32e547fe83b9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8c8b27b82ec02760be4f0aca2906d892bffc3b7dd63a4fdbcfc4ce9b7590593"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebe0f013ce18b00c654d75d8571718a01e170091831d098ad0d6f5f49c5fd8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "debe244558d4facbf4e0de21ae64d3a170c6f525aee4b5a01153de1b0967cac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a328726c2cc08b6d0d1c53897b38a38fd9cf309af3168c5332b175747c3a36c8"
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
