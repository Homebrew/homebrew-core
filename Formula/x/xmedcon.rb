class Xmedcon < Formula
  desc "Medical image conversion toolkit"
  homepage "https://xmedcon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmedcon/XMedCon-Source/0.26.2/xmedcon-0.26.2-gtk3.tar.gz"
  version "0.26.2"
  sha256 "fff4fca2860974b0d2b4ec1c5813c4fc80ca9fa8d44cef6f15ad50eda1e7e5cc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  head "https://git.code.sf.net/p/xmedcon/code.git", branch: "master"

  livecheck do
    url "https://xmedcon.sourceforge.io/Main/Download"
    regex(/href=.*?xmedcon-(\d+(?:\.\d+)+)-gtk3\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1fee4aa59ac8f21772d17208e7dc675ec19a0dfdf3118312c0711c0e0ee152e2"
    sha256 arm64_sequoia: "45b73ae10dd4fef8fa1f6756ebe61477d622104dec80d402705240bbcb268b14"
    sha256 arm64_sonoma:  "b7a935bc56cf0ae4ee5d3b95f93b3afdd23bea7a9d4a31bc57e8a2b275bb9c7a"
    sha256 sonoma:        "1cddcdda434bba37c749ad1bfaae8cfa972f3db275821b2a639bb43b3562e057"
    sha256 arm64_linux:   "6223f3ab44a29b97bfafe457a432c63be2cb1364daeab012a657371b792d5482"
    sha256 x86_64_linux:  "608a20646c7cd3b47c38a2718b33327d3510d6ceb66bf0c9503f6fe3e1a35b90"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "pango"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-dependency-tracking", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "medcon.h"
      int main() {
        MdcInit();
        printf("%s", MdcGetLibLongVersion());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}",
            "-lmdc", "-o", "test"
    assert_match "(X)MedCon #{version} by Erik Nolf", shell_output("./test")
  end
end
