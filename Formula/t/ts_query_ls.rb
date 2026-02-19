class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "88f191fbc4665aea8d8faa67f650ec07a7dd83eecf2e6bc04b87891e64a4e6d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e45c0d19c73ebebf9f95e65cb12b33bbec5c1322fe5dcf16abdfc12b4ff16ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38542b0ad18eeb32145459da178d54e5f174a851cb26de98d1777a54d09bc309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e634a50a355d8d4851cfe5b1d244cfa4beaf6929d60c4cb8dba99040c6ae3447"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ecc8d3da16188ee29f8e903dc6041b49f4883a13d0aeecda6efb3dc0b5835ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575cba83bd9999dacd20b68ac62708bf4bf7649bdb3cf871e06b477658ebe8d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c556344e032c3b69f59c253fba4cde631eb6fef6ee54d7b4e061e853082cbd"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~JSON
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"ts_query_ls", input, 0)
  end
end
