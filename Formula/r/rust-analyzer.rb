class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-05-04",
      revision: "f04c37286472e3687a2d32d3d1fad2772de515a1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac513aa5caa996b788864a5b9336a20ff53be660c439d323f658273e990f7435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c797ed8ea3b6a4f223fa7dac88b9ec87618955721d4a9db854b1505006d3e8ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82abce4bccab6b48944e5205b884dabe235b4b844ec08c65cec50c09cf8cce43"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc9dd430165caf56768f4497fbd2c449d28b6eb20fedaf4ede231e772d1fd4ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c056ad0abf49f0b4d692235ee92c8133932208a2324e0e3a64218318d56b5b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a251a0adde40b59f1187794d34b46029a456be9dc36c93f752a85c4317736f60"
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
