class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-09-06",
       revision: "b73b321478d3b2a98d380eb79de717e01620c4e9"
  version "2021-09-06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2b3cdff474ae3c375232661788acc03a604f553b49058f532480967183e0558"
    sha256 cellar: :any_skip_relocation, big_sur:       "c33e880cce7fcddf6d9295a49e3682c307dc81633886c56a7e792d4593284fba"
    sha256 cellar: :any_skip_relocation, catalina:      "b4fbbfdee38b3d32068cd4f730cef836930ec8cab55dd3e564f393edeeda2cf5"
    sha256 cellar: :any_skip_relocation, mojave:        "e97bb665ace48b2a865673f787c33d6258ee33f7a306b6a10791f984d42a9302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb29c756246825c273ed6b7519ea5261f8862534007e8cf9cec16d1cedf8e09"
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
