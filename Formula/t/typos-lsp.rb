class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.44.tar.gz"
  sha256 "41ae8acf9166e55d6f14bf6c372854bafb5430d65f3c979c58cd61647765fec5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee4603bc38c5a1b95ff8b37925d3a2b409063749d1f4e139ab9c54f7070689ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bedbc80a5559b31674eb2b97b29ea4f7e9e6516e4606cdc555f219ce98cacbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6652ad6ca4b3b992308e46354e2b3c3bbc1537c6ae5835eb12d7a64e015be59d"
    sha256 cellar: :any_skip_relocation, sonoma:        "62f413319a94f315ecc08e8b1ec8f7c9b98873e89baad751521d6555d9af6c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab009c1958c92afc47326def7a491223be71694171808d95a48cf713c85c6a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d992b9cfe774fd262d1602ee50b75df3c3f0ebc8415880ded5eb300515f36a6"
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
