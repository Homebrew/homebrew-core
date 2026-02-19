class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.48.tar.gz"
  sha256 "cecf41f1f0967edb7d4c1ffebdbef9165c710a8fd7117c0f0488f33e8406aa32"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "324b1c0faa1860bb7c001f60e33ad716ef870f2bc7cb5eba93a43b4a43c4dec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "110eb3eea95ff3817cefe249ddecf40de64636af43d098c7ab312c1a9d5f4076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191f9cd52bbf74c6c219827d72ba124340553b6ab2e5e9c178d23c38003b1908"
    sha256 cellar: :any_skip_relocation, sonoma:        "85bb22ba50ba035efb695480112dc9c7db8b9239b6d831781cc4906d2c55f687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d38cde5d6a0f467e55040f3d246c474f971347293947a88d835a5605ba7f3348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819ff5662149c97a583a173a71cfb49cc14bedc0df718c4652b1eaa88d805d28"
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
