class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-03",
       revision: "5c28ad193238635189f849c94ffc178f00008b12"
  version "2022-10-03"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ef292bee23cdde62fb5d2b4ab6cc217e83bd0a9cfc8ea4cedf9d25986e9d543"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50e5fe106657ef909153bdf55269d9db428744217e21dd02349663e658220c3a"
    sha256 cellar: :any_skip_relocation, monterey:       "b1597abfefb3f37153dc71d9ce3348104094f3b112df44afeb690e6d2b6f4c27"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6819e80f91c0c7a44a9d5e63d270ec4677a3e2532fc5e00b80fef19f33b3a76"
    sha256 cellar: :any_skip_relocation, catalina:       "23f3ac524ccdbb32ee4abff28b1960235266cd2c5d32a26249679ff3ecc9ab6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4165cbcde05f5b46cc4b7c7e2678aafbb23b1496529ddcd40455375f6e79adc7"
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
