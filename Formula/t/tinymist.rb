class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.12.tar.gz"
  sha256 "feb042f8f5b39f07eb770137d892c0217a69b6a73d672c275b1169ccd7efeb57"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f0346f69172ffed194c29d3f71cdcbc5706720d6e1948c35905bbca90a7df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c51f8cd21c6c6e227395527158aeb9cce68189c0c7fce7d5bc51cb632896b89a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a490dd30b44221961e14dd8fdcdc5ebb8eb5394b48f92486362d246da6bb915"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef6b7e49195e7b6d3c532fef7da7af0deae45d0c77cf4e1d27cd55892a596ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ce86973b3b508c360f37fffbad70d9de3faefb69a0f3772c47699e4a1b27ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "645a455926a4b2dddcbbbaa76b3f5cdb83b6cd4271c7cdf37eced0b31dbed62f"
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
