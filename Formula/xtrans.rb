class Xtrans < Formula
  desc "X.Org: X Network Transport layer shared code"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/xtrans-1.4.0.tar.bz2"
  sha256 "377c4491593c417946efcd2c7600d1e62639f7a8bbca391887e2c4679807d773"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1738fd7b80c0ebfe717716a192b00400e804df83d42edf172d42acba1cf09fee"
    sha256 cellar: :any_skip_relocation, ventura:        "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
    sha256 cellar: :any_skip_relocation, monterey:       "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "784cdda022187276b0428069a1c57b7f598d4748d2bb824bd483a809fb94ae06"
    sha256 cellar: :any_skip_relocation, catalina:       "74e4e5cf12976f0b9ef865052f6b40b6d3bb17fad1f6298f7cb54792aec3cb8e"
    sha256 cellar: :any_skip_relocation, mojave:         "a84a48c11a607fa66fa70119c46b6a590ee0b744ff600c22c2887a6bdedf73bf"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7bd1e64df9191e69567a8fe7f82e97e6c2aac7a39f3f3ad96661b3369978c861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24285595cf66a05c9399cb7e9b3d1899ff2c494e0dbce260a2c6e4f748f76f0a"
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
