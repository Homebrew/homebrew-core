class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.22.1.tar.gz"
  sha256 "dd7602c069e8411c1a744d5b25f80686339ef18e6f12c1bc971f27912e3e9714"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c1ad59a85a748439e78e998dfd0e4c914b996f78a4c0abbdd19c637e2ab910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e03019cc794440c1a9ed0ebe457904955e8421765d049bccd517968c7831d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecc36bb65ec7e202c625ec583c38baf5ffd0a874822c365edfa182334bf7a29e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0950447d80806cb938eb1b813e0b48f82b73d11c0ee3c48eee762bd33cd21588"
    sha256 cellar: :any_skip_relocation, ventura:       "94388c7f4edb89aba3402755a85898a15fedc30b3eab93cee528ff80f194b1fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7385f6dd598c2b21df44424dba081a5168785c65279c649f837834ede9eecadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5dc9f0178a252b4a12f5de7e12f6ce698d79f834734f8e9793fd077adee4a7"
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
