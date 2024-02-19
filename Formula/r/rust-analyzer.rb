class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-02-19",
       revision: "68c506fd6299c60c96a6202ca08f9d868a0838a3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc11952d0853ad64e8f8bc8dc98082302e33f8e6a4bed058f9be9bc69dd6c9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32312a79aa4522fdefdbe80686245a4a87d603d5851677b9972b9d131b47d105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8865026150a1e144f5f830ec7bb1de460ca35043f32b8b0c2ce9851a1566fb65"
    sha256 cellar: :any_skip_relocation, sonoma:         "443138973ef0db90a827e3a5d0426cedb49051daaac85b3e6cf97c13e54b18a9"
    sha256 cellar: :any_skip_relocation, ventura:        "019312764ea95686c3577bf3ed755707da511b113ded44c0b3a49e577331b757"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b9ea1d8576f0caa003093e4985456a444d1e17f16d8cbf59cbf609c6b72b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60cc6fe1cb8d8c38ced5059ac33eee165b8a4abe0376a0a3e6b5c1fd3f3deb2"
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
