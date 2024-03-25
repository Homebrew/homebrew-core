class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2024-03-25",
       revision: "6f6b03f9de783f91456080b3f6adc8d92903c1b0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dd15eae6a74136964014339ab1a6e86985a741913b82f98837a1f2316ae42a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8659a254a454c2e07c478d9e50c4f896daabdf65d0ee4d00d47a6deca039c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a5282bb9ee76f1e7a0e569968638b6e32ec28f8eb55e2a6ee88395c0654ec0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a33de29c0584149b04e40265c9ab9d5a47fbc206108c5ebc04cad38993dd67be"
    sha256 cellar: :any_skip_relocation, ventura:        "c0e13a481e9ba005ef55de94a2b67613f352cdb1a1ce6ef26e4a6b61acaee6d4"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1c219f8da3e2feb975958f82a83b42c97e237dba4906b9bc9a7ffc9239d783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af27a6a54daf910253c4aaae60bc12448c4673e9e6d95010f38e4c91a33b2899"
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
