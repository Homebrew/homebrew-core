class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.23.0.tar.gz"
  sha256 "f14a3e100706cc217a6720057dea2e30b7c7a3a7297e6d28ea741a533500a1cf"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a1043fcddcb0b323119d934f6015bd7d527401c392bf04793334bc2ea968c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7167522c91211a8ae4e8c2ba08c45a962a6dadec308e2a6e3dd4ad783a0f11a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44a7e15a26ab19850128cbcc4b2ed9ca256727b1ece60e00d8b2f6edd100b35b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d879eab56a0b9153dfb736f67d569e63a0dc7ab8589a40c6fbe6aa3f357865cc"
    sha256 cellar: :any_skip_relocation, ventura:       "c899201ff1089a31969284b8a4e08742b34c776558a0fed129e3a64fa85563fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf43e55a7699f2c8f82f2fdf2f027e2a076067f71445373645b25dc6e7676628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd341599a213d3acacee9e5dddaa4d8b5d2b19b9099248f33af398d2d578459"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end
