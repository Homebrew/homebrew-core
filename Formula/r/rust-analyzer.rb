class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-04-29",
       revision: "f216be4a0746142c5f30835b254871256a7637b8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5a29581ae460fe27849a523e8b625f108414c9207b7f8fd60222dd22a64657d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2196936b667db8df2c53912d5cc50a4e964db1585bac4e3900fcd4ded982e03d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3f1c8513ea624f239e53549cfbdbd0dc4a8120cde2a608f6f8ba42fcf18855"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba1e01401a64343949b6e402ae23310bab30231d7475d2f6da12e2b4c8cfff5c"
    sha256 cellar: :any_skip_relocation, ventura:        "e3d67ee13ee14548c71832c32d3812275a0c5ebc1766f50c75d742f14ca5c70e"
    sha256 cellar: :any_skip_relocation, monterey:       "90ea47b4237e2ed3dadc679d0e792f1e76ba85749a49e2b3bbaf598ec04d117c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c274a93500d3e98934615096bf7bba725ed1c92b32b791ec6bfe33f17fa081c"
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
