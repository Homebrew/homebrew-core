class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-01-24",
       revision: "17afa2e7780f399df99bec802c4ab7d2f920f158"
  version "2022-01-24"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2323676e678222417fb0f9f65bafc00e7a2f73f978d4bff1d93e54140c3a49fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f4c892dbed2103b1ae8d0ab66403515b0c9dba28f294c66447726be411f553b"
    sha256 cellar: :any_skip_relocation, monterey:       "6f1f089003642e8fc8c22cd13f5a8d40887047ff5cdf06173ec2b8c7240a8fc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c56836dbadcf962e94de2e13a45b552c9e0da135b50f67f855f6802023447424"
    sha256 cellar: :any_skip_relocation, catalina:       "2f5de807124379fc3d47e2b204b4e9cee64775385c17812fd54c918fd739a32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b86683777ddc550ba0c8ca713fe0c11ce1c65deb18cbf1a94717a9d9be0f73"
  end

  depends_on "rust" => :build

  # Fix build using rust 1.57. Remove with next release.
  patch do
    url "https://github.com/rust-analyzer/rust-analyzer/commit/df5340386365b2b16c4e9bbae546504b97564c41.patch?full_index=1"
    sha256 "296078507fd4a3b86d8bc2ea2acc8ae87ac908430eedd773730924d53cd3dd45"
  end

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
