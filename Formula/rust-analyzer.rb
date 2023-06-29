class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-06-26",
       revision: "4a2ceeff0fb53de168691b0f55d9808d221b867e"
  version "2023-06-26"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17c569ba4dc2a13e695e5d568d2f630ecdf2b58d50d1ba196bc00cd51221ed1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be434ffbfeea7b35a5a9c8e4e704e3f5ab04489a4ff80302d98fe40ca062687c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8bb9cc667a127061b1a3c94f056d5d33be5a18e9b9ea95691e5f768f96caed3"
    sha256 cellar: :any_skip_relocation, ventura:        "ba05250fe4f97fecac672d0e7dd06885fdaecf3f8f379689e00525b0a24b40d3"
    sha256 cellar: :any_skip_relocation, monterey:       "1de96f3ecfe933c3d1d4b047522232d9856d43419f1cbf497936b297e08ee394"
    sha256 cellar: :any_skip_relocation, big_sur:        "86ad48ce9b6468ae34e8ac3cb9a5e8afb181443637f16a0250a9355a0b591879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "626bb002ba07596ca2923fd2204641887114e06f0fbf3bdeef6c50ea1c5c01d3"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
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

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
