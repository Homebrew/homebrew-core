class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-05-02",
       revision: "5dce1ff0212e467271c9e895478670c74d847ee9"
  version "2022-05-02"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a247815549b81d2996e74643a6c451425a86935c66d938419809344686243933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd751c53d4b3f2ad49bf052a53ff9e52686d8760d6b19bcb23fdd54310e29ef"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb30577eb92161e6df9c9c93990f2f0c988a8349fc79089c65cb81eb2cbba93"
    sha256 cellar: :any_skip_relocation, big_sur:        "be061fdd85739180711ce28c2fcb3933c5aa23640b732bd9cfed3332a7ef3c0f"
    sha256 cellar: :any_skip_relocation, catalina:       "013afdcfeb543c54f3c56756f5e822392759f2a373c91f0a257ccb08f4903aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9359dbc505b828f16e1ec9814bd79ac2162f2c7f315edd77093c1740496f8b0"
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
index 1937b8936..e6f321394 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1571,9 +1571,9 @@ checksum = "f2dd574626839106c320a323308629dcb1acfc96e32a8cba364ddc61ac23ee83"
 
 [[package]]
 name = "smol_str"
-version = "0.1.22"
+version = "0.1.21"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "167ee181c12079444893cec9c8f21b13d6b314af789c9fdb041a0645f11ed9d2"
+checksum = "61d15c83e300cce35b7c8cd39ff567c1ef42dde6d4a1a38dbdbf9a59902261bd"
 dependencies = [
  "serde",
 ]
