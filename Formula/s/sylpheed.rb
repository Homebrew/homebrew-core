class Sylpheed < Formula
  desc "Simple, lightweight email-client"
  homepage "https://sylpheed.sraoss.jp/en/"
  url "https://sylpheed.sraoss.jp/sylpheed/v3.7/sylpheed-3.7.0.tar.bz2"
  sha256 "eb23e6bda2c02095dfb0130668cf7c75d1f256904e3a7337815b4da5cb72eb04"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MIT", :public_domain]
  revision 8

  livecheck do
    url "https://sylpheed.sraoss.jp/en/download.html"
    regex(%r{stable.*?href=.*?/sylpheed[._-]v?(\d+(?:\.\d+)+)\.t}im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "904952d738df66659a845da6b43e2489e4b8c65ac8c6680e999855c5f4460670"
    sha256 arm64_sequoia: "486a0c588d0241a2cdbd2bdf9ffba966f207243abfde699f8353ff0c0fadd128"
    sha256 arm64_sonoma:  "bc084394ebc2781e0336e087aa640b7e7e750089f2ecc93a69c3f7d93b1b231c"
    sha256 arm64_ventura: "46d1569258905a84d21de589cf4da12f8fe4a3b959dea2f0f368819e81fc58b9"
    sha256 sonoma:        "a6994106aad038ce6a2ab01a9618f7d273b0c934bc7951b41025dfc104f4fc7e"
    sha256 ventura:       "3536a1945677ffa298ce9811bc4d12046b767ca08e2d4420cd5b0d7de986513f"
    sha256 arm64_linux:   "75272179dc0352d0181a1617efa6cd7f00ee093145f43d15a327f1baab17e3c9"
    sha256 x86_64_linux:  "822cdb64a23e28873bc5171be5527d324ac69ab52f3c58f423df3ff90b94bc4a"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+"
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-updatecheck", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"sylpheed", "--version"
  end
end
