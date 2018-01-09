class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.4.tar.gz"
  sha256 "82d8d553a0cf2752e71266523f9aac30c1b5a12fa6b1faea8c7c6e1ec9827371"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "a6584e18d4c4434684075c76b30544bf27144721f45f628a792d460de11c8306" => :high_sierra
    sha256 "b1a56447901d0afa3a8fe8b71a04d6943777a927437ffb35eccf10ab812add6f" => :sierra
    sha256 "4305601f9ab24c533e77e9d88a1475489b1716827ac4e39504f76ce30c81348a" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--features", "all"
    bin.install "target/release/sccache"
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
