class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-02",
       revision: "643bc02ded7141a462bc0c9357c8914f9d50fb06"
  version "2023-01-02"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39dcd34ad21ea938e2e2ce1012cf215c96d8fa2780dcfef6e38de58ce280d76e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15a8c73949556da874e4d6ad71b8eb8b18ea7420d641a9a1a0e87568d8ee2bad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03fbeb44c3a3399dc44c6954f2b752d807e6df62016c519b21b9d361d8d341a5"
    sha256 cellar: :any_skip_relocation, ventura:        "b4631389b45414823a08ca63af0309e9957a1fc600558554d865583e0d6ae29d"
    sha256 cellar: :any_skip_relocation, monterey:       "8298b68613c1840db301c55a2b709a58e61c18db74107addd83fee83ba6a33b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d55893d5528b366a63fbdab0cd29928fe3681961fab0e83df404053a423d78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecc1d67fe70fb42e7ea3d1db30ef1bd1dcfb595945f2e2cdc24d5300706c380"
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
