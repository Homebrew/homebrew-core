class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-09-21",
      revision: "aaddfb73fd95f2c0bf001b474dca91ae28bcce3a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3b1928bfe4c74dd16eb01226e4919e3381a3c17cdb77c229b90cc2c321d9f0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cff3225230ae45dc80f153f1a03bdaa3fb47fac95af3ce75217a42eb7f56bf95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51bbdec58fe05584c856d3466beeaa6ae24b386ec5056ea169a4e6e9a6117e7e"
    sha256 cellar: :any,                 arm64_linux:       "ae1ad8330e802b748368aaa9d240b81d1df72005b1d66bbe75ca31fdcdfb8d6c"
    sha256 cellar: :any,                 x86_64_linux:      "1c284897806c042d6be70352e3f2cbb36ed5fe806190a2af5fe42c52c33eff74"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
