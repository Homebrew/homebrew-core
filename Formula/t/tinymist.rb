class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.14.tar.gz"
  sha256 "65a5f90297ed89652802993d0b4b9504b2b5ec2b54fd23935b48976301a046d7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b1874cea802c1427be1379d4687089dd2dd0fc1a5ab8ba4e3b9d6373ab1d872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7825434cbc6a64b588b92013811a5fd67380fd6753723a2b54e41e295c8bb4b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1febcba3e119d4cd87d751a3390b6d89141532f0b1ed1592d5684b7d323e78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb10f453075db815b295552ea29dd372ac9bc17db199d65b5dc8641075da0a3b"
    sha256 cellar: :any_skip_relocation, ventura:       "ea096f5a455031efb11c848426f81be6ae7cb6ea1b9afe38e559438427d04fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dfe4a9d9f768172438778bdbf37ee33ceaf5c6db810b5beaee8b10387d7e060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e38da90107e6373ca7e1df79c21d122f9a13816bda9cd105c04f4aa48f5440c0"
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
