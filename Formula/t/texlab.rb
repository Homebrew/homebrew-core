class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.19.0.tar.gz"
  sha256 "ad72171dd267fd73ecc6a05f9ff3cc068e77a3b82f986305ab455aeade841294"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eff4f0c2dfd3c0e01ac0fd22d6107ac26a1ab84ab25923c84b49a96c7908e41e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebc7da5747cec2b16d2c98999feb03c7280b79e9c1d303b120a882f98eaa6e4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a2fcd46f4bd0ddf6c3a0ad53794076a60baeabe5d0feec2e37dcf16e3ea8a96"
    sha256 cellar: :any_skip_relocation, sonoma:         "3172060c6c8a795d8b5adc553bb37373518547ea48c1852f8c41be4e6fe41f7b"
    sha256 cellar: :any_skip_relocation, ventura:        "4d0e00456b18e7717a5d5205126190436cbbdd935bf49a5069b63466c58fd841"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea7b55c18c2fd747779b4ed105f7a87ac2138f399e16be6cf37a0e3c8b7ae01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0babe89b75be16aecbdf16cdb9b5cf05ca3f864514ce18396a7543634d48ca04"
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

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end
