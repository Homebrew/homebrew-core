class Tinymist < Formula
  desc "Language server for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.13.12.tar.gz"
  sha256 "f7cb81e9aac04a5aafeb8f19161204174d9072935b93df9202f1583bed826c51"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "335525bcc8838724822e6298b806edae38f6cda0ab301b97e485a8807188a33a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30f0cdf15bf36c72045673f3f77b3a151a54b02b38d10e05585ff9d0d24a3a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22e6537840e41597fa49e7b4f356d70ed4c5bba8bc70582dc8e1651a1142634a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd27529d898b7c0bc9eeeded47eebbe4dbe7657874df1796b5f21006e4c6e0b"
    sha256 cellar: :any_skip_relocation, ventura:       "8ca7479fdb608921995a6ee4915e2d5aeaa788e0c489074bda89e98974a20b19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4791bd7361982b67e0a8eb2b369510fce7838fa29254bb35a0781b53565f2d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f78aa50ad6ab929e1d005cd288907916d40e8df3a932bc627db21fc5d960aa"
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
