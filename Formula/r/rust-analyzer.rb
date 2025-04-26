class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2025-04-21",
       revision: "723121e5958cf282db3fdb06970776724a7326d5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121d4892c386813ee6f4cad6578138f7572edc9346c1c2237b05785ad978ee75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a321edaf1b327218cb2734aa02317e99e2a849533cbd9beec30e5d2593711b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e0d6c321eb1369c876bdd566c32e7a6643ac11045bcd3579c559fc3ca09694c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d2846589985937653bc62384db4c57e209e38f151aba95d0b69ddfec45fba64"
    sha256 cellar: :any_skip_relocation, ventura:       "51069ee81df50c9ad0ef5137a3da1908b7ee194e2b2468ad40c12c6397bd5eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0e7908dfdbd5ecf426f9814305da8d6c95bfe2779694c1b19ff5257035a3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432d2899cdd9cf266be3663456e12afe18dd4d420ff260abbcbc2886441bfb88"
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
