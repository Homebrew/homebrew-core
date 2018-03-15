class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.6.tar.gz"
  sha256 "201f4e75307da7ebceed7375a4ffbdcc91c333d5bba06ea07676485685fd4ed6"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "5d0500e016fbc93d4939a433b885ec9a2eb0d8307b1c1bc43de46f7356bfdb17" => :high_sierra
    sha256 "b562291098b0a464249f947614105e565e847b3b3b4590beee38a1035fdf152c" => :sierra
    sha256 "39d0e84cd978d2113fcc6638a9646ea42088f38391eb46c31d03adbfda61794b" => :el_capitan
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
