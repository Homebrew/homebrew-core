class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-10-11",
       revision: "ed4b312fa777ebb39ba1348fe3df574c441a485e"
  version "2021-10-11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5387f521552829d7fe536e283dc1f0ec4d60db42345fff29efd7754f17895710"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c8b4b85507ae7212c5f8a564c88ce0427736512ef75917c6270cfa95b307755"
    sha256 cellar: :any_skip_relocation, catalina:      "b383415686d75dc4f08ede2681edfab5353f6763e0b8edc6596c99165cf2c792"
    sha256 cellar: :any_skip_relocation, mojave:        "e2d21294ce5fb0f33ffff619864f1b68198e939b29864032dd095533c44ac49c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d9e07a08ea8108ba9c4ee141cc625b655df3781f50ba5696d9e6e6a3908b7a2"
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
