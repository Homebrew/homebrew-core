class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-02-12",
       revision: "c06ca6cff5af0fce63d4a28b33e5d244686cb442"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58506a6d0f428826c2b8f91a9b1e346823c8b98379b4edc28f099a2380dca669"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69386b84ebaa77bf3fec51debdc2f54cfae4b5969e76e1bee714682715fcc928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e0b1a8d2e2c20be75fcaad988c18e27915d46e6c7d4f200ce69340bf600a7bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "66cc08749d4d86363f0a5d7f14c8bfa77d7b08aa141dbdfe30aed2d13072e64c"
    sha256 cellar: :any_skip_relocation, ventura:        "9d1bd5ce3c888adef87f9f7e10242bf4834257c06b79e32da2af94ed4a27adf1"
    sha256 cellar: :any_skip_relocation, monterey:       "4f818598bbcbf0c9fd2d8d87524a218e39ddaff318e900fd9acc6fe5a47c230f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77294a4375d644b92786f699abe2cda9ca02f44c2f0956f5974772725a29905b"
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
