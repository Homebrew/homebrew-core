class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-03-11",
       revision: "574e23ec508064613783cba3d1833a95fd9a5080"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5c5e78056bcb076d28ac15a8c7270d0e265ddf26d3b03606ece894cb7a09d28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93eb358c23a461dd397b32a72a378f7ffa3aa7d368458814ec5d65ee460a9229"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "474f13f5989cc96bf3bbc5c85c3130f5abe85fc5bac82d1f2fff95c6523571b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e816ed58f737dc544918826691218842793a52d33a3b8271fef1f099de1cc04"
    sha256 cellar: :any_skip_relocation, ventura:        "96e58b19424b79a09208cdfd0a1e17daa2c38fcd6218eed5d1936cd0c579be93"
    sha256 cellar: :any_skip_relocation, monterey:       "d54a1a4addabb85ebb51d543b409e218d2a8a701a401fb7b42856076f3113ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74882eedad38ea506a6612242d4e009ba8d91daedb988638c5035f4e4301e3d5"
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
