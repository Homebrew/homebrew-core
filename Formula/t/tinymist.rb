class Tinymist < Formula
  desc "Services for Typst"
  homepage "https://myriad-dreamin.github.io/tinymist/"
  url "https://github.com/Myriad-Dreamin/tinymist/archive/refs/tags/v0.14.10.tar.gz"
  sha256 "215c08d8a10ff51e15711f0684eafc85d119dc98db57f4f47ec7bf5987ea681e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141107cd600ec9084c0f23aa6d17237f46befa0ea399f9c45ac0950948771480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c59d1f7108e44f67d21de944a49aee909d28a6477d44b8bb5f850bc7269588e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3994687ebc60daa4f52deac832cbde58b13221ebe4adfbfd09ee8d9d7158912c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bed8575ead5a60d5fffbf620bdff2d7e685cb2d7818aebbdd9160a5775b0fe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb341def15d08ce05ba41de06e10355b1416203347dbb8392e458ad6fd3e6cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56aeaab347eb1a83fcee80aa29f9007f12214d72fc3f733e5835b01e3c2bf1e"
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
