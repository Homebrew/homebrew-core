class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-06-06",
       revision: "ad6810e90bf89a4ef0ae21349d077050bc2a4fa2"
  version "2022-06-06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5202e358f835110bede624c05c09b0cbfa8e4f48152495d816c89a66a42237dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c24dbc224ab2797512438a5ef93ea76cbbf7f4712e19aff274820486afc7c86"
    sha256 cellar: :any_skip_relocation, monterey:       "72fa19ad4e14a103f23d507db9f51afba2ae88ee9610a8cbd4bcd4ee462d572e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3b6d1f1d54da527ba69a98b8b9c6d7878b97743de0a6206f2cc5c430e73884d"
    sha256 cellar: :any_skip_relocation, catalina:       "1f2b80ef0fdf93d1ea3baa9b80f45c2aa08ab7ec78ca3f9d3c0de98fb2b2f6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf7cb2fdfe3cd6b58f3e7fbf04aee26891e7b87360a67d3315352b91830aefad"
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
