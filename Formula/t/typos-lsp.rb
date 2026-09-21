class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "e23730dd4e34788274da702e1a59b7a2cc7df76c75e90eead37bec5eea3d0cbb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3cf48c6ccfe226d9909d43679806df57af33f714a505d2f2fb2667517917eb3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab5ae5ef508a5c37514509930fcc20e42ec26d17c14269533a96340f9b010c4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e302900a9bcba810fbab688bd96c5954115dba19ff01df62f291fd31d149ea6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f3f7864a66498ac99a179d6a11fd261d88b5018483ece2804d4e7ed4fbda2c8a"
    sha256 cellar: :any,                 arm64_linux:       "a229f6a7e6a8d20acbf9b7e1a2224fe340b5dd1553d1c12ebca5e3f123804efd"
    sha256 cellar: :any,                 x86_64_linux:      "9d636f6282b04d20c860ba996e254147a3b7d4c4debb57a4bd884b9ac0fc0df0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
  end

  test do
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
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
