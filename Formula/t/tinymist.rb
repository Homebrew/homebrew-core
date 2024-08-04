class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.11.18.tar.gz"
  sha256 "e4da8240c21e93f4828cfa7d254f90d27d0e02dbaa0e4fcff00d617a139a294f"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3339438613692a7ed80f4de1eacc4f8c300d66eb292f8489e89cb1bcb48c1ad1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe78eb126230ed7e7c0fbf532c1bee540def7cc874db34bd7f846dc8adf7c2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e4a671f2af95a6b3f30334ede64fd986f4180082a4824b8019b60e5a8c1bcef"
    sha256 cellar: :any_skip_relocation, sonoma:         "8627120d673631694986a1810fb7c505d65cfe096601147943ebe5671e862239"
    sha256 cellar: :any_skip_relocation, ventura:        "0fc82ccb3b01b47013ae78401817cd704408bfc7fafdb47227b8bafecbe636c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a9310aba0c9d98ed5daf2280d0b72b25e0e811a9d659ec9f2fa69b253acd9e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bab32ca1bda3dc6c85ff8073a006eb014614442f6cdc889af3ddc074951094e4"
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
