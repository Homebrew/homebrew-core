class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.5.1.tar.gz"
  sha256 "be07d0302bc5cd98960367b926b9719e020cb32dc270ea7fc3a4c6177e53a5c2"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd219a42dda66638bd50d8ad2dec1b5a504c7e0310066edeada9379c9a05e309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb0676a5e6bc7d4146d0bab9e0b8caf30d8f63b90c9a85b28390d36441b124f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23401dd510167baa0bb62909f8c200ccd81ae19c632c27c4328dc882ce3f67d6"
    sha256 cellar: :any_skip_relocation, ventura:        "fb22780e9a8f0d1cb11d12879816f87d5db3caa85b406cd6ca421f77a205e9f7"
    sha256 cellar: :any_skip_relocation, monterey:       "c22619ca500b52129a9cd132301173858430edac1561e92972ca8bf15efc697f"
    sha256 cellar: :any_skip_relocation, big_sur:        "794456723f863e197f92f9fffb69f031b928145b2b669d88de016a47a3ef1d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffca5c9f37cd0fb0d553c16a690f876cd895e291513cf663ba26d1bef17acbc"
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
