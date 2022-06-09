class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-06-06",
       revision: "ad6810e90bf89a4ef0ae21349d077050bc2a4fa2"
  version "2022-06-06"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19596ae1c7e4a16adc4952b71212f77524b298ccb98324ec2c9aac85873bfff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef82947142117247e9a79d40e7a2e34abc59d49c07858477089c57ad675dcb69"
    sha256 cellar: :any_skip_relocation, monterey:       "59dda23d68f1144b4e52403d6fbbaf3cb4a9ea615d48ddcda52e0305b5f2e3f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "46c21b6798aaa52ddf2340275969aa746b32175356f70caf1b82d027e97f780f"
    sha256 cellar: :any_skip_relocation, catalina:       "680a40117febb721ec590d75aa0256b2d0d36edee4d150e3c0ff311a8a28d3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5e529a2c004b0b51189d7b78017b2bab118228e7aec8651673b6d438638ad68"
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
