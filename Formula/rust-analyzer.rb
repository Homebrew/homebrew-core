class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-11-28",
       revision: "6d61be8e65ac0fd45eaf178e1f7a1ec6b582de1f"
  version "2022-11-28"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a71d331a47e5bdd5e0a6086d515316382b42dd6492f1d419316917301c0d50ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffc2ce83dba0991a533f189817ba44d0edeb263af7185ae9ee4a76ce7c3af706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc00c402e5e6ebb3176f22729a57b1467ed0edf85b4471a6317b8041df34af23"
    sha256 cellar: :any_skip_relocation, ventura:        "a66622d7e03beb5c76f84a639e4317eb948a18623c58a443edf14fca6a61fc34"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7907365f843926ef57105cb0da85bf51fc893c96bcbf4a1a423d0e562ee030"
    sha256 cellar: :any_skip_relocation, big_sur:        "9382a21eae2fdb3dc3a7c659c70c6b674a241d4508a646ac7c91bbf584175e41"
    sha256 cellar: :any_skip_relocation, catalina:       "9d46398a43e1566a9072cd8eb7f301ead5ca6d1d2a3195c6a59d0a652e3ae7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a9a7b272cb13075945f79aea1e5f6693f5f6411cb1db2b8c4222ddf975fa43"
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
