class Zvbi < Formula
  desc "Vertical Blanking Interval (VBI) decoding library"
  homepage "https://github.com/zapping-vbi/zvbi"

  url "https://github.com/zapping-vbi/zvbi/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "bca620ab670328ad732d161e4ce8d9d9fc832533cb7440e98c50e112b805ac5e"
  license "GPL-2.0-or-later"

  head "https://github.com/zapping-vbi/zvbi.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "libpng"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"zvbi-ntsc-cc", "--help"
  end
end
