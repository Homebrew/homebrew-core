class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-04-03",
       revision: "236576227a299fd19ba836b1834ab50c948af994"
  version "2023-04-03"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc00be3799a8706a53229c4a6ac3b535e0b06f809e1539e9d994c65d5145846f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80a9b702d0f7b2724efac12d2c814d3db0c6bb947a556a96d15b2f69afc31ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f383a9d5996a811785a86b374af3432840c49a3d4cf0c3c311ca58960e3a3161"
    sha256 cellar: :any_skip_relocation, ventura:        "23a7b0c239c95acab47d04067cee52e5ad79b215d11ed95df85ffb1305dbb608"
    sha256 cellar: :any_skip_relocation, monterey:       "bf22eb6e3c2c2414f913cc8b9c6234a192824549304b8aa97704d1b69b6e3e81"
    sha256 cellar: :any_skip_relocation, big_sur:        "acd7b32ba26bb6349525af4443db71970932567a05bf515fd08b292e81d9303d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c2c6882458d56e2f97049cab9397d2ae1bb0c5863fdceda20b82e65d7ef5ad9"
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
