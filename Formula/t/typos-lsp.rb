class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.37.tar.gz"
  sha256 "a1fc610814752811bccac1cc2a75b86a2475df7546a6051f4618c5625d286a1d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a096a4453e5b4f20d8ddb20e87abac2539c42230e2cf29daa0c5af58565c40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ffd1ecafd76a83b10cccf8858338686a90e9fc89e16da98fb9a5ff1a5b8fa5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ccdf0b65429819ad75c9a00fadec5fcacf05c0039f8a295973ae72b3e0e9a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1ff0a88502af0bc61d093bb9cc471c927b3584c06aed939ca1cbcd67be055c"
    sha256 cellar: :any_skip_relocation, ventura:       "f49f5d49dc645a6417045bbc7767d71eb12f9795f583123f4d7e3244d9c12ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "002ffc822da05839fded73487b51dcff18b10584789e7e5abfe876be4ca366a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0cd6f7c9324aaabefdfa19538c250772aadc76fc43cadecac10219afcefd6d0"
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
