class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.1.tar.gz"
  sha256 "b142afa412260a706af9df8fd831928b5d86faa10b208ab5daad30a9cfb318b2"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "3ebd09f4a69a469fb913e446f18830bf390065e54ac4d65500b623857ccca4d1" => :high_sierra
    sha256 "c5a38b08cd4062753359bc3d08cfbbeaaba2b9e0a367cfa6bdeccf14ef4c0697" => :sierra
    sha256 "0ecca586f9be067fd8740a0f758029183beabf44a8f1ba20668e91cd25e449e7" => :el_capitan
    sha256 "20232467c2fb91032a313a819fde0e44115f3191ddde6b6b3889a8ef02e0af3e" => :yosemite
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
