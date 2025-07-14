class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://github.com/latex-lsp/texlab/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.23.1.tar.gz"
  sha256 "32620d4a186222cef1140250c9c43b83ed873a4710d05a0075c7d8f6d1d4e1ec"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fee556e6a2c725957c32b65a59500bd7adb03cb57319eaa15666158c8b2605b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29430f50ee9e097237afbf400c6c91d3951fe935473ab04f04473b6e1ff7cbe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29382baa39d72a6422765c4c2cbfcaa266d386182c647e1f8d0e16bb72ed661d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed41c572ab59bebb88e88aa24399844538105ba02741d0d3234968e88f4501fd"
    sha256 cellar: :any_skip_relocation, ventura:       "fad936dedcc53c4c8ebf1f78c24d08c20cbcc93d91f5478e5174525a273cf87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccad48a8a8632a97b43968a01b7a2c1823c9c1205971ee96207568ff3152fbce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3329bd28e85c19c343c61e6b4812c76649e72275a35bc0eaf018fd94a899718f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/texlab")
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n\r\n#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"texlab", input, 0)
  end
end
