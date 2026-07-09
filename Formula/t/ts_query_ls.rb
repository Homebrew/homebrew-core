class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "2e145fdb7fef06ac73a77a377d5e879af41c8e7194928abb7c2536263b2f519d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34334ac5ff1df55503f68c0d045dad01355c1649713de6558af6c11c085e314b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e0b494e12dce3d824e2f9017f80021e004cf6e0546a17e3524dcda04d28ea3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b24186fb2ea6af7e2d927191d84a55624b0c5879bd1757a9784c5ae4ec4971d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3a25bfe01cd3b80501a8e5e92169e00670348adf05d4c22a83319a0cd852d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8016e9f2ae358b6fc7c02c7e17f431da6c1e5d81e8a3f852cbf5f141f0eda8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef863729111a1b0854d5928d5c52aeaa2a9abbf572ef13a35c1d5b29f06210b7"
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
