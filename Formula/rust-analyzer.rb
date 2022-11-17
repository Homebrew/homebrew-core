class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-31",
       revision: "ba28e19b7838e3ad4223ae82d074dc3950ef1548"
  version "2022-10-31"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f46b04420bb7541f2af173dcb8e0d3bc142e896b984a9718d97b40d58322dd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "770637d37a242b836d3bbae780fb3475206af19e4fd3d019305834899cd4671d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f10f4a81aef079103234091c4ee0903eb90a0000ad39cf26b048902597d3885"
    sha256 cellar: :any_skip_relocation, ventura:        "f57ca55c90674cc895cfeace700eed6699ebf461a401ab33d8381d76c98504bc"
    sha256 cellar: :any_skip_relocation, monterey:       "b0aa6b647a9077d399c9bb856e3295523ae4b52db397b86aeb80e29fc4c27346"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eb8537546fe821cc1f28a3020926e4bec8946020ab87e81d019eb4d1e099c26"
    sha256 cellar: :any_skip_relocation, catalina:       "e50e634127e5566ae5ba1381a183bd657257e828af7cc901eaa7aba586d36348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a597b86e02e881dbcf8c65178d7530a5f512576b62a6087f01476caa20ea3c"
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
