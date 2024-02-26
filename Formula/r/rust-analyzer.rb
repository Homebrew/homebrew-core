class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-02-26",
       revision: "5346002d07d09badaf37949bec68012d963d61fc"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15e16ab6a354867c6394d18a38c564830cac107ad4d3030fbfc2ceb2d3b71a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e38b9ef3b5872a01108195bbea89f4bef3388b5507ac8a0d44fd97844993f02b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1b2ee75ac8fc03702ff44b13b9491555f051f78c034b042d165af328132071"
    sha256 cellar: :any_skip_relocation, sonoma:         "8909a2512d4b052d951ddad1efec6ccfd7239bfcd8b0859678c2bded472f7ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "e51c1b99f187308293d6523a37e8a88933e0835caa3d8e2c5032a081a676abec"
    sha256 cellar: :any_skip_relocation, monterey:       "877f57d630089479f30a27e81596d6308c80ad162b7d29123d01043575da0add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e7e12815ffc2c9d97c7de1a8fea7bbdd5b7ab936e01427bef95636936b96f4"
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
