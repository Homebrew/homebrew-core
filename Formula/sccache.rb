class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.9.tar.gz"
  sha256 "a24cf714dad8f3f1a50a7ae32665451e36487e3c76f5d92d57f5e4ef7176c0c3"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    cellar :any
    sha256 "34dbac945a8df83497f5aae52a3bd915a280e5b12e1b3928b8d9001c04a43695" => :mojave
    sha256 "f9d8d617558c29f78dc3631f4e7b32071d7cac8aa65d6de0a9b72fc42b0554cf" => :high_sierra
    sha256 "e40cd1d872fe3b16f81160ad0cb6426e9dbbe0204513bd3f1ca1421119f64166" => :sierra
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
