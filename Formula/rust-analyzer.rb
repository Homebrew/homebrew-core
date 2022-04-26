class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2022-04-25",
       revision: "b5d7a712e1c5d1e602feb8320f902ee9cd6ec197"
  version "2022-04-25"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44c2a3bdd60ceaaed2a843288c23a8a427b6893570e520672260f5b43417977d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "492ef2edff6cf1377d434f43959e64597b1c4b5a926d55943d3306ce9371c401"
    sha256 cellar: :any_skip_relocation, monterey:       "5d872027b496e763322bd9721a4ab2203a420ec85d0be569bdd590d70fbf4d34"
    sha256 cellar: :any_skip_relocation, big_sur:        "e49c8595ba493977ee4d9a27b8b9f4798a005560c5bf0da33986a2159e90d9e6"
    sha256 cellar: :any_skip_relocation, catalina:       "a4bec52c08f46540b64b3791e723dd47a2306f2c0465b3fd3a871efe55780709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed15a9ec219866e7fecd2b96e40afe0a8c6838feccf093af897c91660b2830a6"
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
