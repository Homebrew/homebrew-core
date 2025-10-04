class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.20.tar.gz"
  sha256 "fbb1717f14803501d19859b699fa714f73888a299f3fda1953a5b5de48186f83"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fc605e66514858eaa55fa8825d8c75d3d4c42bf339dacde1a7c06af0f4dbab4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f9f30eaa1f4c5ae4e41c8a13577ca8c3f66cbedd30ca18616aca5b2fc34f071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc20323eb55e59d6938ad129cd9df2fe3b7399af85ca0f54156bba63289087c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e92a65c03142089ac9d394f6aaa9f56b1364541ecaf0847bfdad143768434e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e83d06cfdd5e548b59e4c519e6633b20e02eb8d975ff1e4c01ab358d6862504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec9973c48feaf9111f59a005eed2b2ee03ec8d40d6c677090141c04ca7d4c5a"
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
