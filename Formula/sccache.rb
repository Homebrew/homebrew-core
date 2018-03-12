class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.6.tar.gz"
  sha256 "201f4e75307da7ebceed7375a4ffbdcc91c333d5bba06ea07676485685fd4ed6"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "97afe82a53186e7f45e1a2034766c6333c7fa81ffc8325e25df8566620a055a7" => :high_sierra
    sha256 "c2418b2f7631293068ded33558088237f96c0d993f4a5957cc9ddb99649a62f5" => :sierra
    sha256 "d3c9818cd6ea11aba71b6db5ddc321b4701331b57c78aa0c8dcce8bf20e77d3c" => :el_capitan
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib

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
