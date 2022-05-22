class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-05-17",
       revision: "7e95c14ea730c6b06f5760c8c92e69b9a6def828"
  version "2022-05-17"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a25b1ebab3dae9b1169fe5405b464def37f73f81a109d8c0c7577a93605edc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4afb9924327040680e61d9376605a3beff527d79063f3c7aacaaefbe2662780"
    sha256 cellar: :any_skip_relocation, monterey:       "bb15b3e00a154af7f3080d6c8ed1b22c5c63527e7ef73eec7df9bb3abc600127"
    sha256 cellar: :any_skip_relocation, big_sur:        "b651e69c346f092e94652995b0f37a45738a7147fa37995ccc4e514685f39b0f"
    sha256 cellar: :any_skip_relocation, catalina:       "d397c5a9c8002461209f411d9d4ba3f4a1d982f8a1595b1a63473ffc08d39084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7089165abd5367c657f098770bb1330b36e06ad7860d9e36fa4aaa14e257ed5c"
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
