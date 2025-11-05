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
    sha256 arm64_tahoe:   "0ea610b3af0db757bd189bab60fd9f0ce33d58ae8aa7fce209aa4e375a22e26d"
    sha256 arm64_sequoia: "a1fe23b7dbd8951b5031eee67dc408932e51c395d444f53ef1ce29cd8948551f"
    sha256 arm64_sonoma:  "3b3b70ab46313696e589a386a1a9e76c967dc0e95ca720198e0210be7ee90d07"
    sha256 sonoma:        "d917a7034103f2cef93248e3247728dac9647b9de7704a26e9ce0aaa1a887a2e"
    sha256 arm64_linux:   "c302b804a122226813a871e29f03c119be83a7992e136970c8852ef24866b913"
    sha256 x86_64_linux:  "4a0749df38aa92f298e0c7250ed55fe1cdff9976d2c1a738c77850df61815a2e"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "libpng"
  depends_on "libwmf"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around build errors with newer Clang
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-int-conversion"
    end

    args = ["--mandir=#{man}"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

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
