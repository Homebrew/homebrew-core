class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.3.tar.gz"
  sha256 "ad2f11714b6d37ce5a49c91dda609c5f7a3913e988596cbe9847083ee4358254"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "294dda365425fc050344d7dce9dbe53ce7b780e754b0cb6b87ad8d1c04860501" => :high_sierra
    sha256 "6ca47428771877fd3ce58df83ec5dc7b245a3d0c00f50059e2eb0259cfc3fb09" => :sierra
    sha256 "e995ed15ee3c3b6c9a54c66162e8dcba9dc4a8d401724e0c3ecba6636a9a6c65" => :el_capitan
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
