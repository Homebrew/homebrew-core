class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.10.tar.gz"
  sha256 "e55813d2ca01ebf5704973bb5765a6b3bdf2d6f563be34441a278599579bb5e0"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba0c41eb45d18039db95d7c31c5d35cf1e5eb66ccce1a2694cfebab21bc6c414" => :mojave
    sha256 "831d5bc1937a834d0f7ae710e3a1178dd1dbcd21215987afc37a7fb745981ef2" => :high_sierra
    sha256 "5d32a0135b93eda3bb44afe10776203ddc0809850303dbf4efaf3f5785d2dc8d" => :sierra
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
