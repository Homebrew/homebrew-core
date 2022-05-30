class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-05-30",
       revision: "f94fa62d69faf5bd63b3772d3ec4f0c76cf2db57"
  version "2022-05-30"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23a8fe900ebea91296923a3d2c4dd510df4d1e02311a80107d78bca77613ff13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "943c5b60a248c5d907f1e42e079c55880052fc57660a0c8b732e90b926ea7403"
    sha256 cellar: :any_skip_relocation, monterey:       "33a61c237352ad50ead4ba34b8ad7b8ffd838ea4b875d64aa0f510ddb65f08d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "04d46ac8e0608195fccabefe4df87bed7d4543f898dc2cd71ffab8fbfcf72bee"
    sha256 cellar: :any_skip_relocation, catalina:       "47c8ce990019a1a5b9ef33d6b9e83029430849266420da6ef840812c36e67c85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc875e93347e516c36e38745966675e5be4c09431c985b36a692f7b78f417ee"
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
