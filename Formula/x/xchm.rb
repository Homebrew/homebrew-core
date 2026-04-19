class Xchm < Formula
  desc "Compiled HTML Help (CHM) file viewer built on chmlib"
  homepage "https://github.com/rzvncj/xCHM"
  url "https://github.com/rzvncj/xCHM/archive/refs/tags/1.39.tar.gz"
  sha256 "e806a6daa6db115406f75f6c1e969734db62dd000b39bb7d55e0ba4c1a88ec16"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "chmlib"
  depends_on "gettext" => :no_linkage
  depends_on "wxwidgets@3.2"

  uses_from_macos "libiconv" => :no_linkage

  def install
    args = %W[
      --disable-silent-rules
      --enable-optimize
      --with-libiconv-prefix=#{formula_opt_prefix("libiconv")}
      --with-libintl-prefix=#{formula_opt_prefix("gettext")}
      --with-wx-config=#{formula_opt_bin("wxwidgets@3.2")/"wx-config-3.2"}
    ]
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Usage: xchm ", shell_output("#{bin}/xchm --help 2>&1", 255)
    assert_match "Unknown long option", shell_output("#{bin}/xchm --foo 2>&1", 255)
  end
end
