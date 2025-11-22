class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "36cf8b0714ef918daa626c27c9b6d2add7d6ce741323bf51cfa29f455a707ba2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9d02cd0079f3968781ae67fc49c8eae36be1d27c69368071440d3fec8944d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecb3116be0948e7365b191c9a8a039f470d5d8f7e7440ef548e8b9f42616997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fb5ca342ae842b169111ed378e0e9bffbeb872761b8018bf243379dcf9f01cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "34ec6f23f015b498b94091578f150a2328b34f8277664e94e7655e4efbf7d976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6819adfbb48f8a3065664ca9a81226237e3ce50cc15d1698adc235e53d57e3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e51e680cdf5550937d55278abb361990a5cfc3ac195c2498c5bebaed9722c12"
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
