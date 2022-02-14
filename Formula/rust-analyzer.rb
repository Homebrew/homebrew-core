class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-02-14",
       revision: "02904e99acc3daf39b56ed18aa07e62aeb9492c5"
  version "2022-02-14"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc9906029e3ddb0ff7e4e7fb311309ab9a3f2283697926950b13a9a8a232fda2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d7b87fcf2859fa6f8faa7110bd5ff5fbfb56e2f602680d6c9569a571f3412d"
    sha256 cellar: :any_skip_relocation, monterey:       "d90922551e911671c4111ddbe19b568481cefe154fc44276d79707a0dcc17e47"
    sha256 cellar: :any_skip_relocation, big_sur:        "b42e8491eb7b683fcdc02af939a1508a02a491ffa937939aeedf389f9f1385b3"
    sha256 cellar: :any_skip_relocation, catalina:       "75ce599da6f62ac8e4961d20fa7457ceb44628b6dd347be6814f9062b83a724c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fa796056e3d23d7078d601b9023984e13fec1ef35b1862b13f7b25f0e728a98"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

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
