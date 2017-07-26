class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/0.2.0.tar.gz"
  sha256 "441d9ffb4ae76cc8219ad4d372c1c3335dc81a144d795663e58161f25e1dc651"
  head "https://github.com/mozilla/sccache.git"

  bottle do
    sha256 "09c5615fbbc77ede76b3152f89263c956968fc16623d3a49df1ddb5c1884e575" => :sierra
    sha256 "1f54c022f6a760b18d1e05bf8b75a6981a9c4039b7efada98d47a0a0e83ec767" => :el_capitan
    sha256 "cdb270d1802117dd470792ee04d0c722a58cf899c2428432efa4ed9b3fe88efb" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release", "--features", "all"
    bin.install "target/release/sccache"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
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
