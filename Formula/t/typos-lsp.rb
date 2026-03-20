class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.50.tar.gz"
  sha256 "6a71fcb9836eae286d08b5a7c5bc2f4dd278eb9d5bf7031ba585315a1714b666"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9113ebe6aaf348618c19199ed469220877583a8a86299f60f201e99e80c98a42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92e9c1ebbffd1d75131f000a6309be3865a8c0059f36514682d0ca908f4dc336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "452ff4ec777fcb0b8a47fc8b66c9020e355e3e9055df7ea4697c57534a5e7752"
    sha256 cellar: :any_skip_relocation, sonoma:        "531b181daa82a5b5c82772268bc5db6909fd8c6dc791032faaac2641c1465c73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a0bf2fc3b1f9620c1119b0a7e046af7d0a3a4dcbeff925cfe6afb854a4069ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac8ff42d892d755e74d87b61d53cd02083a95d8bf0d5ef46237c0493b7df92cd"
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
