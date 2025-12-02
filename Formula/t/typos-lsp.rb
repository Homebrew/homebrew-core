class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.45.tar.gz"
  sha256 "4a4251c72a5cb0f7cb23439348d8a6374a047557b890ccaf581c534d0979f2d5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea5b30f11f143c40fe9aa0f17a2757017ee2717aa0ad5b64fd1cd4ad608ed37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd71d665f26c227c23b4179884eaa317d5b0d36b83a09076fd5248bcfdffa87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e554c6cea71c81d6c3c630130695908fa39544546d00acde0e83cf65d554401b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdbfd415ba77c34f2ce7fdf2425664cae885613322e80c557f46166a06edd56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75a8ba3f5f23269c1f7a322d627f32e622ba82072b7039fa0f1fddc48e5a9a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7dda1efcfe280a33af29797acfb63fe19dc5d075cbe88180a326a6ab1a5221f"
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
