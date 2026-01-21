class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "22d4d682df5ad56496da6965e74f0a89f00133c22a30c1c07f1bb45acd841aa7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b57227cca825bda57d190ae14ba15ad84add86254b78f70d7cb91e185264040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a9848d94c16db3ae6d25e54b7e834fc1931bedfb3e2725e15a149a6fc670b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7089799b9fbca088cc2be33dc75a751672c94e271412dd25243f4343e457e84"
    sha256 cellar: :any_skip_relocation, sonoma:        "992d957c9eccbd7b321f5a4ed892ae04beed06157c287df20c55286ea1056d3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de14db163fe69d65314fc0cf9a68a5e8da248d6f410d593b12336448ea95b9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e33e476b3382e68dbc6bfbdbbb431bd9e2897a0d433c54d3d23f4bd725677fa"
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
