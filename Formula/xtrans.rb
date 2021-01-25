class Xtrans < Formula
  desc "X.Org: X Network Transport layer shared code"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/xtrans-1.4.0.tar.bz2"
  sha256 "377c4491593c417946efcd2c7600d1e62639f7a8bbca391887e2c4679807d773"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "784cdda022187276b0428069a1c57b7f598d4748d2bb824bd483a809fb94ae06" => :big_sur
    sha256 "1738fd7b80c0ebfe717716a192b00400e804df83d42edf172d42acba1cf09fee" => :arm64_big_sur
    sha256 "74e4e5cf12976f0b9ef865052f6b40b6d3bb17fad1f6298f7cb54792aec3cb8e" => :catalina
    sha256 "a84a48c11a607fa66fa70119c46b6a590ee0b744ff600c22c2887a6bdedf73bf" => :mojave
    sha256 "7bd1e64df9191e69567a8fe7f82e97e6c2aac7a39f3f3ad96661b3369978c861" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    # Fedora systems do not provide sys/stropts.h
    inreplace "Xtranslcl.c", "# include <sys/stropts.h>", "# include <sys/ioctl.h>"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xtrans/Xtrans.h"

      int main(int argc, char* argv[]) {
        Xtransaddr addr;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
