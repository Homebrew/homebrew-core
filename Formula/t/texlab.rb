class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.13.1.tar.gz"
  sha256 "4ce3e078fe9008056a48c392d2ba8e89cfc5f289be041a714d5140a150e11224"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b1a7b733a24d4f138fd0539c248c8c5aa74c95c7bd6983890a64236eeb7838"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12b612256e81f98ec8c9efc0d89ea7c35f0c6e0d342ef8b825f5b5c8ba48fae7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "843d3d1a11f3d49da44e721acdaa6b28ec8c6e61d025eb34a6e4315d44e08289"
    sha256 cellar: :any_skip_relocation, sonoma:         "5deb0ae532a33536717ed939e9b27d0c821d538f25f1f0c52c04c64fb57219ab"
    sha256 cellar: :any_skip_relocation, ventura:        "82a048329f4319f49995befc056977d973f3c59240c28467f0e9d1e70c85dd5c"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a9d74e872aee0edaea4dcc52f585e846359e42a64723833570e0fd70c92f26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9417fad44d99dd74c69f82a3aec7838ed91c6f33f98fa7ebbd44f4415f74d74f"
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
