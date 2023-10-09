class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2023-10-02",
       revision: "0840038f02daec6ba3238f05d8caa037d28701a0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d33f62e82e38b2ef19a50eef6ce6830ca706e21d321dd123d2a053f0bdfd520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce4c1dae9203fa427a323f9ff6ffa3c3e88d66c38d385518b447a921bebd9214"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c7ba6100d0077e3cebfe7c825aaed599a44b5c93d177a490a5c98c1242c455"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5f909429b787e829d9af96fb89367fa38351116cf00acecc8c983914012a59b"
    sha256 cellar: :any_skip_relocation, ventura:        "115baa028af5612f4fb7c4b0ae544293f95d4226fdfee2eb46cd91b9dc2269d1"
    sha256 cellar: :any_skip_relocation, monterey:       "2ab389d2d8c393941a47aba38814d427b6ccbcb766a0ae547e983d5ca470e4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81bc3ab39f4b0ed4f1db12d58573b2caf35f658f3efc8e3157c3002cb7ce8dbe"
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
