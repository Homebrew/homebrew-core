class Wv < Formula
  desc "Programs for accessing Microsoft Word documents"
  homepage "https://wvware.sourceforge.net/"
  url "https://deb.debian.org/debian/pool/main/w/wv/wv_1.2.9.orig.tar.gz"
  mirror "https://abisource.com/downloads/wv/1.2.9/wv-1.2.9.tar.gz"
  sha256 "4c730d3b325c0785450dd3a043eeb53e1518598c4f41f155558385dd2635c19d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    skip "Not actively developed or maintained"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "f43fdf4000603806925c2d0e26fdb5d3f5d6be5c435478964c8dce92484784a3"
    sha256 arm64_sonoma:  "99b64967c38d1f679aabfad54fa6412939af4e571a4b467541d69be0b3e42bad"
    sha256 arm64_ventura: "c121d0e251c7b6a83cef08a85ec05cb2a0c9afc2ea72adc9b70a0bb9f399417c"
    sha256 sonoma:        "d6cae767da3de4f93a2e601054882abfa09899cb71ba6d6cb3e1735e29a36fd9"
    sha256 ventura:       "40c5aabe6aa0fd8f5e9f91050d788ece1dfa777e0359f652b2c085edf8d60bb5"
    sha256 arm64_linux:   "15690cfa4f200e96488ba2bbeb4186f0b9776b402011668a974abf6bf16416c9"
    sha256 x86_64_linux:  "2ea81d55829b98259a212af78e40fb74d6ab9a83be165a3d7f2c6e6cc91f753d"
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
