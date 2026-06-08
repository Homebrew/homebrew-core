class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.net/"
  url "https://deb.debian.org/debian/pool/main/w/wv/wv_1.2.9.orig.tar.gz"
  mirror "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0b1a7b66a5369c2e739d1b1b39315a0813672e1e3a314e9656d4e3be6bf4dece"
    sha256 arm64_sequoia: "c0ae3245bfab0575b61cd15afeb41080e5e8de9c0c032855b882e2186faec7ac"
    sha256 arm64_sonoma:  "e1a3352d9798bbd49a719cf55050f1f68982b6e57b361bc380dd7ef1545079ec"
    sha256 sonoma:        "708f70cc17691035a34e92db0885c6e868f44ce29a6f224f5630ca10cad1b42a"
    sha256 arm64_linux:   "ff673a4f8e3c22e69aa7c4692145d0a5a48bc60a32eced373d875dcde0a045c1"
    sha256 x86_64_linux:  "6f66b42660930fafb95f88fde932773f48f9742b8dfb94c2a5a96e78a89fe7a8"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "libwmf"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Work around build errors with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-int-conversion"
    end

    args = ["--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize
    # the makefile generated does not create the file structure when installing
    # till it is fixed upstream, create the target directories here.
    # https://www.abisource.com/mailinglists/abiword-dev/2011/Jun/0108.html

    bin.mkpath
    (lib/"pkgconfig").mkpath
    (include/"wv").mkpath
    man1.mkpath
    (pkgshare/"wingdingfont").mkpath
    (pkgshare/"patterns").mkpath

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/wvSummary #{test_fixtures("test.pdf")} 2>&1")
    assert_match "No OLE2 signature", output

    assert_match version.to_s, shell_output("#{bin}/wvHtml --version")
  end
end
