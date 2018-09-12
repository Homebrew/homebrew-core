class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.7.tar.gz"
  sha256 "0f7e3ad60a93759a35623aa954633c94154fd00d17fe29f9413933e1c5545a52"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "232e1af12684c02a086f8a937caae4140488153ff3d5be6ab2e30cd6aafdc3b4" => :mojave
    sha256 "5142c49377699e069a1332b4fb681fef05fff6ad406ea1e0596786fd4f192e76" => :high_sierra
    sha256 "e3687eef1ca2b74c95b48c2e3df2cc4d985afaf7fd454b9eab6b4837c1e9e24e" => :sierra
    sha256 "ea3758d1bfefaf31d085b8196b10d20248e5b7f2bada51457adf6efcf6411729" => :el_capitan
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", ".",
                               "--features", "all"
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
