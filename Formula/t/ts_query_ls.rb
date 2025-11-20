class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "65ec3634b29102cddef7f53615c266bae2c2f18690b08aac814e7f317fc1167e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c019af3cde68b1981083d51dad506f861cf9a32fbe1c4f011f061b67f1a55021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "578fc2884b6cea31ba9a3ac075ce443880a2920d263445c5481d54e200d02b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43dfd90a0fe6bc8e06bd536af594db98cc6eac0818cd266f9387e448a9361b91"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a4973f6b6e121e6662def9b6a5cdb58bf58ba9b4b3dfb276d6cecd9e2100b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27ca5fcdf30f5445bfccedce9f16b3b88f3bd10164342c6b47edc7f554340156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e898bc331803688882722d11407c233ecbed7dfb814a1a3c983155e7e24d30d8"
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
