class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
       tag:      "2022-05-09",
       revision: "5d5bbec9b60010dd7389a084c56693baf6bda780"
  version "2022-05-09"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a976b807e49fab1c904fdf22fe14c2ab9dd380175556045cabb67078e03c56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cdd545c2bf412cc1d46b099c2758c40f062cbdd434e1b866b4cb158da1c046f"
    sha256 cellar: :any_skip_relocation, monterey:       "923e7fe4dfa9cfbb90c4ccfbd3dbea636c5b38552d603b3263a9bba60ec7aff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "93329c551ed3a1bf4a119eaeff27b79f3fedd2e338eeb96aa90781f2dda43506"
    sha256 cellar: :any_skip_relocation, catalina:       "1d317a59fbc5388c4fa3e40a0732825e93efe01ea4f1c3b5689003247ea87d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75b137e33e8a02af41f67a20b7f97ac5acca06cc80c91de237034e007fbca22"
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
