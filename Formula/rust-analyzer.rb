class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-01-16",
       revision: "ff4d55e480470fd6e3c3c003703612294fd09d15"
  version "2023-01-16"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8def89d1b3f671a6dea54dc7cc40154714d630cf0604bb081c96be648b4f07bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6613fded487ab66fc0d1148973e5dcd7bb95d4a17c717d24b7225e4fed0474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a520c3b393a0a643b3c5880d833794e9cdc14829fe1b3ffa05f75ead987a9ff"
    sha256 cellar: :any_skip_relocation, ventura:        "4b4dbe6e7d23571bf349b987989b4cd01a431ae1ba611883a5d74e16d3700b9c"
    sha256 cellar: :any_skip_relocation, monterey:       "45cc44eeac1e82fdda3eb69f793e2b2bdd20944ba12349827386204de8c13ba7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f807417edb92af7b236fb39130d6941aeb8e7283e266d3e357c4ad46b47c024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ed1e4f299e90a7418328274de4c18f5bc4eed913d2e502e1ea2545e6daf017"
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
