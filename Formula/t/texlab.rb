class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "18f2f75768076514e01b9cb837a78ade3b0772140fbfc32f490a5fd9693dc639"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8646fe39edf57b4ed467403e53158329819610661beaa283fd5ca3a9a759d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81443026a2370c99e622f1a065a178928e337be99d5425a2f8291d4bd1242030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd4fc73f852b7a9c15cf75c1882d467d86339ae8c48500e920be6f01c7b8d36"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac644ebd7b295da266abf669b8f20634ac266b167e794bc82dbba13c76c62746"
    sha256 cellar: :any_skip_relocation, ventura:        "44f724661e5c788054166abba7f5f58a02c1d441436761db49e9db7cd4c35526"
    sha256 cellar: :any_skip_relocation, monterey:       "870d428b1f804c27db36aad500abb15faf33a0e2bcfc63e8b6550f32fbe89892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2afc8931660cda45a501ad58f0660fa4bf4dd1d03487eb530ede4774c6b08074"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
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
