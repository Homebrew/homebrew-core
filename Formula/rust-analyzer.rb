class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-05-08",
       revision: "833d5301d1ac47b2d3f0a71b67c5887f7481cc4e"
  version "2023-05-08"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16ea0965191d6f4946d551f72baeb5725711d6a8678c066ec804888a100c42aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846630896186e9432e5e3e1f0973b0b6e4480b6cb3c3e49230bc24b8168eca13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "616aac8445d6a3acdbff64455e56041d8cfc53704f34d92f05efb445ca4f9ea4"
    sha256 cellar: :any_skip_relocation, ventura:        "83b2fef6dbbee36053e4d419153260fb57768f32518ca602df4444c341e7712e"
    sha256 cellar: :any_skip_relocation, monterey:       "8154ae1bf12bea8a82231eb5015f582e1fe2d85f78a97cf71da83f404cd91299"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c4b89c0c818efadb18710754b5ab2e499ba1fda5690403826b921a4309f10f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d06ee2c113a56af9374b1ca578a4f866847204b9c80f7eaad8e9a08097b874b"
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
