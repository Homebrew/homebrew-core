class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "69d4d72335aeb981ab5e776a1d19799d8e0c6fa833d8fd898ad823af3a12235e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991ae654c2abb5fccbd1e48bef0820cc96e58df818676ce3873d7255cac9d08b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77ae3dfb8487d09a26fa7fb982c3d619bc4702aa7ab27e224f126851a2f79bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5af5a5ba7316df9f838326c4b0d286cdec752906ca1118ed24e199a4515f0b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab3444f100a329b808850c290c0f518b636a95d450f72930d931d111b3a68f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ccb75964169de2fb63287725a0ea3c9ac9b9572629b6fc44e4653790f474b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26e3794504281aa7607f28c35c5c56397239dffb26104bc801bea70e004238d1"
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
