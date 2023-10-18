class Texlab < Formula
  desc "Implementation of the Language Server Protocol for LaTeX"
  homepage "https://texlab.netlify.com/"
  url "https://github.com/latex-lsp/texlab/archive/v5.10.1.tar.gz"
  sha256 "e511fd0d274a2dae7a71a2b092c50e0be93a419d4d7eb6984ce4a72ccadd14bb"
  license "GPL-3.0-only"
  head "https://github.com/latex-lsp/texlab.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2459a0ae24eeee7fa234d2c4c6053b38e4e8759010ea13fbcf1dcce9892fecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0162ee2f5e87b72ec1f6d482ad60246ea6089ea0cf23f713552f2ee716269b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568150abd4a51a80363e0b5e803af67f6040ee67388c6bda7e3c7bc7527dedb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "0802f0d27fa900536b9598ae8c47deea5400d98d6cad7815cece808ade78de30"
    sha256 cellar: :any_skip_relocation, ventura:        "621372546cee15f35662f2b79ce4c80941ca7a657a987b1efab144110863c09a"
    sha256 cellar: :any_skip_relocation, monterey:       "77176e83c678a7f832a2faf9a16b9dea8d92f7906afa20b54c01e5d117147a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99aa5327291261a8e6f9cab391687bc84882044ffd51efcd99e169459b777656"
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
