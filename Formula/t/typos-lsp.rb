class TyposLsp < Formula
  desc "Language Server for typos-cli"
  homepage "https://github.com/tekumara/typos-lsp"
  url "https://github.com/tekumara/typos-lsp/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "c48d852d4834091b52fcd82bca386d74657924097d11222c4fef1e7c3c569e07"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "906565c2de063f9152d8bf3abd4132455c3fe31eec9c5240abc6a8cdf06bb2e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6324b6065ddbc9748d4feb834e5479db1839e318c8c92fb282001573d9cecc2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ebdd9b3ce874d0178f1205f952aac139e2ebb8a749d871362d204334afdc12c"
    sha256 cellar: :any,                 arm64_linux:       "8b0198c4a0c89602f24d22e181a611d102155221872d38b8f51335449df2933d"
    sha256 cellar: :any,                 x86_64_linux:      "b418f6fa6eddbfecbba874a5e5c7be2bcc174bb008e988c21812104deab07e5b"
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
