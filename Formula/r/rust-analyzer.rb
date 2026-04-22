class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-04-20",
      revision: "adef948679e1f550805eeb2a78d10e25c0279f54"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feeb305cc7f6923b4348f6573aea82302c2531630f9a750e20c2c5ab9dda9cf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59cbbf8050b433eb9ef95f04d4abffa9f31e8a8ca30f91825c9add215b41378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f0cf7e2f32e570770df8f5f502ac2baea96992417306d8439f6daa5f22a119"
    sha256 cellar: :any_skip_relocation, sonoma:        "90014bb609766882698221cca5236b642c817981ba413f248d2edfecb482820f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f07d3f4e1b6f179e61cc29ec2225fef35846026beef7541a114083a74803710e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e242ee00792ea364bf91ba25abecc4ef963917030d99ebc2e4f125f826dc2be5"
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
