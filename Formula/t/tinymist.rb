class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.16.tar.gz"
  sha256 "f9c8f33ac4208f7f7d3a56f3005645cb5959fd8bceca56488c7016a0880ebe1c"
  license "Apache-2.0"
  head "https://github.com/Myriad-Dreamin/tinymist.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09763abf42ced27b737f5a8a816ceb344fc7b73754d9598fae34b98d4d8c2ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f206361e269787b7bea96f1199b2383eda58d3eef94325fa525e017a949d70b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea097622323b25769b3d3420c7aee2c1508fae8235547274379da009d68c4644"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1fad36cdd952c7680996783641c124fbadf0bc6af89dbdb0fa87ff06c1817cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad41a7492bcb3767a50f04d3aac4d1acf53f7a83f064bb821b4b3fa33e9d550d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b41032db15f98cb20e298493724a51e1d4c45623c8ab834fa5dccf7c10fb48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist-cli")
  end

  test do
    system bin/"tinymist", "probe"

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
    output = IO.popen([bin/"tinymist", "lsp"], "w+") do |pipe|
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
