class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-05-17",
       revision: "7e95c14ea730c6b06f5760c8c92e69b9a6def828"
  version "2022-05-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c941297e2788c7cdc925ff943c9641c278ec80eec8fd48706907cf078bf40272"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3258dc143151d93cfe45764365bd3646decae4f1011630c45823b7847cd712b"
    sha256 cellar: :any_skip_relocation, monterey:       "4eaa83926d558e3168379b835857e4164cb072f87b0b911be9acfb6bd980129b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b02414fb9bbb7b9f22d0f936ce92b9dce7f8fefa8629ec45f5707b3f622cf42c"
    sha256 cellar: :any_skip_relocation, catalina:       "1bf8ced3d40c2008989c0bebb4d3afd6dfc768213ab276a7a11a0827d599b51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9497ef3390e71883f7c718314b4b4aafb3e1de9e1d7ad245318c6962795b497"
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
