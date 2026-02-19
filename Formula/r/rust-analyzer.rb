class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-02-16",
      revision: "00a9173e57f5c4ba45e380ce065b31afb17436ad"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a9ca32e4c9e98478fdf67595f399e5c9c8efe692df858397ec4f9b72bc8bf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a63fe9b4e803fb4dc507b0bc9ca87cbd50b1fbc066721cae10958beed12fb6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38c19bcc9debcd6b69d005d1370a20794665c2433d5bb1052950f8cb4e37b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "004033d1dba52da839feb532ea5e6d6ff468d4ad8b58e089d0d0323379a82b1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c4a084ec2bb0a4b27553b965567bb2c852c4154ace8353de30193aa045c8593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b5e46fcbe84078fbf1a9c65a700c20a598899f03bea9d7bcb5d33bba6e1ee89"
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
