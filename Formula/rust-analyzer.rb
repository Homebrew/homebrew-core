class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-04-20",
       revision: "d906b7ad889209bd09a6cc3af752fea06e4d953d"
  version "2021-04-20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f37639e4efa15abe0f6a94bbb0778c496555b3241764c7e50a7d0377c238eee"
    sha256 cellar: :any_skip_relocation, big_sur:       "d031b75b4bb4b446dc75bbc272ddb82029a6fa1c884c831c5c7499ad57f7b572"
    sha256 cellar: :any_skip_relocation, catalina:      "3da8beac909f1197ab3d4190fc21e42e34a32cf70b9ff74bf364604192590575"
    sha256 cellar: :any_skip_relocation, mojave:        "930e54dbfda4e6d083ae489debc0544e2e8d8258704abc36f1468b4fab287ecc"
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
