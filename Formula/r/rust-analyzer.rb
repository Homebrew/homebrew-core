class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-03-23",
      revision: "b42b63f390a4dab14e6efa34a70e67f5b087cc62"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d727911407376f6da0868d4708e887c8286862841f0f80ab11aa6e38cd97d2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "996b7107a60465d24c3b1b9687b13e3eaaf8bfe48592438ff012793cb25c39c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db8199ebd7a59a38a9da1614eecfc30820a14863dd8547dbbc0e235961230a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d15d47ca09c9598f5df7fe2601da54d837c043eeb178cd6f2c1479752f7a5351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5aeb1d866e35877b9264c243c8943a4ed0a248b1acb8969a4471db623639dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d0da809fbcfb66ed148f2f529b3cc3c5ada65604fe68126083d3e2d14122e48"
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
