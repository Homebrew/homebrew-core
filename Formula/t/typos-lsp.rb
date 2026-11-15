class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.58.tar.gz"
  sha256 "cece3ab47c2c54aebb57cebe6cc3511e7391f7482145fb34f581d81f6f8d1f2e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6935fff6a7ac7c09ee658896ccc947bdbcffff64e46450c760202eb698cf79c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d9e3b18dd978fe48befb55ce87e3341ddc25bf2bbb06737aab7dce2cdb2291b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afc55089ec10aad4ce044f6ac0962e251354f748fc42eae5df17513c6660316d"
    sha256 cellar: :any,                 arm64_linux:       "854e86a910974b3bc83958fea28f46ace36dcdffe059457167f4cf76c08317b4"
    sha256 cellar: :any,                 x86_64_linux:      "e76fe5e64bd4fef94f7a488ec41249a032f9802c8d740602853150e3fd2eb253"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
