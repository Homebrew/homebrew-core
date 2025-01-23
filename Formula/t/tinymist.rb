class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://github.com/Myriad-Dreamin/tinymist"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.12.18.tar.gz"
  sha256 "2b31e22fa67a253ebb06526018c890b2b2f03b45d0870a142d4b98a56ecdefb5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dfd74a6b9ac77ff04e0c9a2d334fc7d720f14e360ae11006c3a60fd351dc404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fdd1b746570b93cffc1c6655c52e7708b4a42faa03fc4540a3499293bbd75f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dbef5e3b4c1c58f7951f0e4ea4a007c54f064c5562c218279069ffee89ea13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "23fec44791cb91cf136ef7567b30fda5d9736c003c7be8b472bcf320513679dc"
    sha256 cellar: :any_skip_relocation, ventura:       "5c6a215b52a5c34b627712d5e713abff12713fc15ad68e1e525b09314a5c71b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00ce036bfdb276eb6d5fb033e063e16c5c180290b52dca3c87fadbd137f54a47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tinymist")
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
