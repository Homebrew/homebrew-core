class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.13.tar.gz"
  sha256 "81c973cf9a89e77f02a6b5710298531ba2e50d2555e8a931e505fbf570522e2a"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4e38444e682b90e9cea144347e5f1fc32ab309ba448d495b025bb9bb19906d4" => :catalina
    sha256 "80f2b3cfa57125f7fd927b8b312483ca91c146dd76702d1a2e0cefdac5ae25f5" => :mojave
    sha256 "071e45205799343d3f2be7c3779292cbcf32d1bfa1861f70af55e9cca50fe891" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
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
