class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-05-16",
       revision: "ac4ce4259b906e7998695722b5af4cf2f261b250"
  version "2022-05-16"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e790d8bb3c05101f73f93d2fd0c76b7c88dab743ce757f842cb7397b48c8481f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25dbe409f76620498222dc42c7c734cc891602e6b17bea71b06d32899a5bbc6b"
    sha256 cellar: :any_skip_relocation, monterey:       "56e8c4cfed7998c169fd069a9b2d2da9955572598f7cebb49d5faac4c2573a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "4523fb8f7033abfee4a3a2ff324ab80c1aced72ea0253b2506ab6059a1aa7348"
    sha256 cellar: :any_skip_relocation, catalina:       "b6da6c46ae02a485eff6010aa57ae9e44f949146d5f69136a69cd92aedb7b99a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97a89993e5d999c4411579de6486c340918e0415a0bac8abd4e81bf8b97f5540"
  end

  depends_on "rust" => :build

  # Remove this patch after rust 1.60 (https://github.com/rust-lang/rust-analyzer/issues/12080)
  patch :DATA

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


__END__
diff --git a/Cargo.lock b/Cargo.lock
index 62b2ac86f..bc06c853d 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1546,9 +1546,9 @@ checksum = "f2dd574626839106c320a323308629dcb1acfc96e32a8cba364ddc61ac23ee83"

 [[package]]
 name = "smol_str"
-version = "0.1.23"
+version = "0.1.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7475118a28b7e3a2e157ce0131ba8c5526ea96e90ee601d9f6bb2e286a35ab44"
+checksum = "61d15c83e300cce35b7c8cd39ff567c1ef42dde6d4a1a38dbdbf9a59902261bd"
 dependencies = [
  "serde",
 ]
