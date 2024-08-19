class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.11.19.tar.gz"
  sha256 "fb520b104e61126426b0d536bbcb2f87577baef305cc3dde25a10c4db3c5dfc2"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb74cf9afa536fa5f76e46986501d7e3f7db6b237a3ba3bddb9ce876d6719b60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103c66d81dc20dcbb235a90e26f1065d73f413c7646f8da6d52e0e007e36bea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82b5d88dd7d2163e0985f1c8cee6b7f9b5adaeac9d2e7798df0378b135f2ee6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "03dfd8f91fef778ecbfc24f8ac3b0d09ea85c31a3470aaf2f879db7861c55e95"
    sha256 cellar: :any_skip_relocation, ventura:        "36ad579efe79793b95dc4a798625f53d503204dcc25ef08196c5bd225cd1533c"
    sha256 cellar: :any_skip_relocation, monterey:       "0f703cfbb0d83e032d4d1dd5ded0557a97f39e73489031cef497bc0f40c40a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc835574ac057bfff8c1064e63134d7482eb22a300dc7931bf501ad5d77b4a4b"
  end

  depends_on "rust" => :build

  def install
    cd "crates/tinymist" do
      system "cargo", "install", *std_cargo_args
    end
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
    output = IO.popen(bin/"tinymist", "w+") do |pipe|
      pipe.write(input)
      sleep 1
      pipe.close_write
      pipe.read
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
