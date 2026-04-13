class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.51.tar.gz"
  sha256 "8862ab28e57faa4447c90b0a6cc615300f4333f223ecab7a34d4cf813f4c11d5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daaf41931ca6b20ae874b85f1acf6dcd1dc9851084618596f2e7e50683b32522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda581a8c92947131e96dc996171a12539e1765c155edca7c83776087f06b99d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ece41e7502014545b8cd2ca60854d78386911849e1bb9740081393352812375"
    sha256 cellar: :any_skip_relocation, sonoma:        "381ca6aa6326ae4de1444f58a364bbb18733f9aa2246c8c434305b5a71e1526d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "549f5d97585f4cad1f6210917c8f7d16e6d347a456b2bbf6971cfa48a1f72069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a1bbdce412d05bf49c1d3f097d69b775db0421125812596e067d6b342964b91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-lsp")
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
    output = pipe_output(bin/"typos-lsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
