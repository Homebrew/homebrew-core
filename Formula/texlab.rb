class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v4.3.1.tar.gz"
  sha256 "c0825077c79e4502b05b8aa9762cf409e47ccd3f3c6bc30044a4c00cdb4e1c5a"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0438680f9171ddd5fd153cec60db8594c4fe2a44dcaacdad0f5392259909660"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3721887e71c7b0f720f11880a721092d752dd52ae4c106627507dc35f0c5ac85"
    sha256 cellar: :any_skip_relocation, monterey:       "a1f133639667e8fb9c95d4d2b80a3adc3e2a6e9e013b4efd1b4fd295df06487f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f1d75dee910316730cd3f2a21d46100df416949e3e258e7c918aaf42abac327"
    sha256 cellar: :any_skip_relocation, catalina:       "600af14882f983fb54dbcffa85c3ec76cf409a37b7fbb62a97ac5135156cf7a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c60a20b1a5a92d548a0467656b4e048ff3668b4a0f29adc5be141407be9d5b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/texlab", input, 0)
  end
end
