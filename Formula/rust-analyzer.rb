class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-10-17",
       revision: "0531aab522f25d6aae30b2cc23a09f4b9257eedc"
  version "2022-10-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df0f11278753fb041132e275332a82704e16e847ba40b7f01913628c198ff346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f27891237d45c877e967e348ede4a3f4099d08ee8a7a0e03d1eaa9dff44cb18a"
    sha256 cellar: :any_skip_relocation, monterey:       "146cef94f4f983b3ae6960dd8d0ed1789df2b561f69ec10435ae0475f17b8500"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e53488b08496bba18670a83e3be857db8a66e0127c24680ee3a5d7bc72ef644"
    sha256 cellar: :any_skip_relocation, catalina:       "07402b3200ffe74e007d31928c67ff1c006c6dae05e98c5b155231016031eb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86b93539694b1a833e2392c4cbc8a6c40384b7faad4cc5a256722aec7eeed69"
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
