class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-12-27",
       revision: "68319187d63707fa36d7c215ed0e444e87d9652a"
  version "2021-12-27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "859c99136b3448a985bf3f2922f7c456bacc345bef32e38f62a76f02bc0ca57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42bf1df6e79371df731cb99e8f202b8d9cd0d3250912beaa4e33b7b0435198fc"
    sha256 cellar: :any_skip_relocation, monterey:       "601c211dfdc1efe00067f4baf37a09d30a0f5e2a7115f236e0347acb29b082c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebf19b3fd12c05b1c7278c80bc16adf5b88123dec7cf7447484064ba28951be6"
    sha256 cellar: :any_skip_relocation, catalina:       "67cd68a62a3ef5fef5c0d50b10e1f8dc7921ced7efcfc03522ed3b0dc83eadbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e8eb67ce4df1fb60dc4120b5832a1a4f9a17f75977547b647846e752050bb4"
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
