class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.4.tar.gz"
  sha256 "82d8d553a0cf2752e71266523f9aac30c1b5a12fa6b1faea8c7c6e1ec9827371"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "739775beb4c6fce238257d8a86fccbe4ac5a2ad6df529c3257927b3f82f8c2dd" => :high_sierra
    sha256 "3b77c7d0a1ed12c8b87a23dc471b64728f75c18d8503ed5148533f3932587015" => :sierra
    sha256 "4e35ce007525f9a207f70667af85313774cd0828b416d82a429e661342407943" => :el_capitan
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
