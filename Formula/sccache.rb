class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.2.15.tar.gz"
  sha256 "7dbe71012f9b0b57d8475de6b36a9a3b4802e44a135e886f32c5ad1b0eb506e0"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02f4a0a5af2c1c5cf446fa67ad86a535565e1d7cc84f18a596216cad4492eb68" => :big_sur
    sha256 "ae7f1b07fbd74584704a0b9acde2899bf1baf5e4eff460e3b27441cb4289840b" => :arm64_big_sur
    sha256 "900c42698ed29c08b034fdeaa990fde48baf9fc608399673d99fb15ade0ba3f7" => :catalina
    sha256 "afc4e8ae1f1febbea962db840e49a89079b67af20e6058da8b302bc634c9d60b" => :mojave
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
