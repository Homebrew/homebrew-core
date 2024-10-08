class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-10-07",
       revision: "2b750da1a1a2c1d2c70896108d7096089842d877"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d2f67e224fdd1c30973a6f2ccffaef42372f1e45cdc2ad74506d9210ec80640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed81454663fc865076b9d0f3f6850561f5e950b88b43ae5402b05b32819bcec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "871b3fc7a78eeffc8359360f664688fdca140ce24f87e50f02ba5d52b3830123"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1c2eae4ca2774ffdf142024deb7a39e64f1843f3c03a4d659acaeed1acfb9d"
    sha256 cellar: :any_skip_relocation, ventura:       "fc294bb3364913518198eb1029347f0d8978f585c1c1dfac24f73f1c20e78ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf604cd984b97837730c83b3bed6a8582d421fe1eb125a4669471db08e302c0a"
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

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
