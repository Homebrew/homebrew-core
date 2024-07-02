class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.11.13.tar.gz"
  sha256 "2efb427083671e11299d7e0a029b67da691730b417c7e5e53a2f60caab3e6fc6"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3df7dc534f43c1f97f8b1fb93021d94e2c475469b00f3b6d2e7a626a23d752c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7ad5a7d6dd31336312577b1d8ce90cd05f34e34185740201d0ae4ac1cea2294"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "216b7126598fd368118d8dace14b043bcd51c0f97ca1aceda5352d638425c18b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6b0501a298f5760b2bca4d2ff0bed7c3da730c3254ce9ffc1e18faccfcdf14a"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf5b1a2d2b27b03569997fe3e660a1d206441745a16c93cc26e95fe2620add8"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f57a7cda8c8ed9c0c0b222a00a80e75084db1e8aca1e1682da9d9228aa91c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28dea3031c248503e22bf961f79b5f30d2970b2abc4ee4317241b7b7e0839cfb"
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
    output = IO.popen("#{bin}/tinymist", "w+") do |pipe|
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
