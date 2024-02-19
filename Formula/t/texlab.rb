class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/refs/tags/v5.12.3.tar.gz"
  sha256 "13bb412563cfae9e7f9bd6199bf029058a59ebc286f9809ce66bcbd43f3f9b92"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffd3d254799865edb09b63f79cb659cce3b5ce286c1667413f7ba8b78a9b9a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09706176284b616403cbf71ed2ab3c29f3340eceb2907aa5e1f1ba7a7fee5039"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d64c70f48c43058136e0f32379ee668ac27d371a2e3c5dc02416064e1b5c8d77"
    sha256 cellar: :any_skip_relocation, sonoma:         "9860b8d4fa2d09604a0867212dbbbd20b8f610aa79a3c22983bcc81ff2aebcae"
    sha256 cellar: :any_skip_relocation, ventura:        "dd4c87f917cf02364fdbb4adcff163f98442539fafbbbb44b4bb29f54f791d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "9265adfaa3c672235f8a5cdc66d6eac55150f2ca5f1f27f2bcb98a9b239b3548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4d4850e87e0bb1e2ad339d14f548ae84a398b5adec9103813dcae9853897f4"
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
