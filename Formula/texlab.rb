class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.7.0.tar.gz"
  sha256 "0af42d00da72114704a234f26ca4ec603e067ecdd03a1f0b7002445bfc906f4b"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a5c6997047cd5ec3adee3387f35a4557335f3e8130eac8402e08fd9fc3a41cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50d5184b9401c3c04bcbd780a6bfbc048f38f7c3c619be8d50e435b808ff26ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bd35f7cacc7ca1b1c03f0dc575e5a747f1d100ba2eeeebc709b05136f23f33f"
    sha256 cellar: :any_skip_relocation, ventura:        "ba723311fd5bfe0becf784b587241fba32babe5d6820f9dda62a9c4974403bec"
    sha256 cellar: :any_skip_relocation, monterey:       "c38bfb8f8d6f2be0026cda13f673cebdff3d0fc13dddd1b285601a08fd87695e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eb2c8923f8ddd4634ee4327011a5eead57d34946467155bcddaba3fbbea2795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "934aff7b1e6f70ec88c8d38fda298a15be9c9cba0d91b62ea18b4b55e37fd54d"
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
