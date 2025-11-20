class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "0a5dbd53e9bc3334b153f996d9fdafb52bed76fa59b27e759e9f9721dd490c1f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0630506a5c76d938509170054914e1f1b6bb65412b3f7c4e41cec0cbff6dc87f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1604e50f99a084dbf5ff291928436ace931c9899a32b0b492bfba3246addc5e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cdd0e6c91906a67400d7d9fdf56ce7c09e1000f30f7fcb20e228ec0731cf7fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "199c7771a980edcb37fd65fa9c6acfe484d1bbe36a5652b98f96d448f54c2195"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffa2f1283a361b638a0e6633dabfe9a0c3b3f74ba388618b709d512f6491135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f693ec1fe9141211f2ee5ba1960b3d84fe40c047e7430bcaa3cabd759da9d25a"
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
