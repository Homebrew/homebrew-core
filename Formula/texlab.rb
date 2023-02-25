class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.3.0.tar.gz"
  sha256 "c33ee9674a8b54f658e993437e6cd84237e8c619e50d6be639eef3be6970f471"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ebf392f4927124749e2d91a58c45d57145e8a5bdaf4e17b4be33ee5082168c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e0f053734a687ed5093b588eb42e633b0e9c29dcd37bd103857b4a817c4e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cac7cd410793a4718873f1ec86b965a7b483941681a4702768cbe75da4616e33"
    sha256 cellar: :any_skip_relocation, ventura:        "fad829bb97317bf11645b6bf09453f6583ee18793ed8cb4762de3ac327f4ef0d"
    sha256 cellar: :any_skip_relocation, monterey:       "1a586d9afc9fa151ba749827803c7a061e866cc04d29ceb143ebcab2f06d6f2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0fc2beaab4e595d8625553637e87790a605384ce76ba29cb6236682c2da9b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47c26616ef6c3026b7a6e64a8f83d3c5836a3339e914415dc4e9e88f46f8c02"
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
