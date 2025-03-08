class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "997d4facdd4ff6f5e4962e88fb12bc0d8943cdd7a2768efb4732074c7f621c44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f746f85ff1208e965a04304c9a45c0b263531b95745e5db1eded7c818017cca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd0e5216832fe4dc8b0af7c1a897231de5878670a60bf45ed1b10170fd9f33de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94a4b0bb303c21a972093b50ad0c9d48afc2316fa8f8a1d005882c933bed1ec5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0de5961ef972d56a0f92ed68f6e8a90d37a2aa02da6885b7a3defb7aca3a2ad"
    sha256 cellar: :any_skip_relocation, ventura:       "acf23a44b146518d3df4c062c9997f47561dc56abf03907f566a9792d2e6002d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf84cd3a9b618dcf9a77c0ab0788c8cf687cec18f2df858ba275712165419ac"
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
