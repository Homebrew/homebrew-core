class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "f0ff8daa615aaa199095d2c1f2dd8505d2cb2a5d83b852da7dd70c00245f72a2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1a1eb5c77528df670856f7390dd2cb06f46b82f0c30a970192fa5523305dd3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a200b4ea9e5c4d353029c1b78d90b14663dc36b33479727eb514e4fdfbb39301"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86d4344ecc0de20cb85eca3f3d1f7b275e2b86f1e4311fcfc183b12205bf19a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1090d660b7041f167751f676922b4c82a6d5cc35f3e70cae3f16b3a66b5d4c8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b471229f958733efc1b254f19d58ccdb8090077feb2b1edca4881adc13a55fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "557da5eeaeeef2903b5ba1dafa48b98f359d7e8c39a804fc0e288f3de60b5fa3"
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
