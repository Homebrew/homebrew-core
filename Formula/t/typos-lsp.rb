class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.52.tar.gz"
  sha256 "0234d322518d67484336452cb5a6eee4129b2b693100789a35fe33c09746e76e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d729289cebbeeafef87962377457b0a6eefe205ff9254fbab18d9d23ef1d3ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce8fcadf5f2d9a0601de907e34309d0471ef30048cc709e0767a916c42d3940"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "add71e7fe15238c7cedbedb1389b079a7b7abd90504462097bf611063bdfd6eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "09452b4683b695524636abf3d5a02956228a93328e8bd562309fbe8efdbcd4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c507d3db31663bd1f23d0052e6aeb2e9b02d121c16b7ebf3e4baef660b10a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "986575aa2a2caaa35db320a8cab39b5ff928ba89eda49d363571991b1787baa4"
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
