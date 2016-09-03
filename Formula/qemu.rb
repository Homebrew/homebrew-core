class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "http://wiki.qemu.org"
  url "http://wiki.qemu-project.org/download/qemu-2.7.0.tar.bz2"
  sha256 "326e739506ba690daf69fc17bd3913a6c313d9928d743bd8eddb82f403f81e53"

  head "git://git.qemu-project.org/qemu.git"

  bottle do
    sha256 "e3802bf39c41adfdc58e877d25fecda661cd5737873c86aeb3037243be2b0bf5" => :el_capitan
    sha256 "6b0fb1d54be15893b8118846e77da2a67332c16d4522d6b68262fc022a13b356" => :yosemite
    sha256 "cd32e67207fa57fe7d378b916a71363c68b0473a2a3c53effd353d673376c43d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libpng" => :recommended
  depends_on "gnutls"
  depends_on "glib"
  depends_on "pixman"
  depends_on "vde" => :optional
  depends_on "sdl" => :optional
  depends_on "gtk+" => :optional
  depends_on "libssh2" => :optional

  fails_with :gcc_4_0 do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  fails_with :gcc do
    cause "qemu requires a compiler with support for the __thread specifier"
  end

  # 3.2MB working disc-image file hosted on upstream's servers for people to use to test qemu functionality.
  resource "armtest" do
    url "http://wiki.qemu.org/download/arm-test-0.2.tar.gz"
    sha256 "4b4c2dce4c055f0a2adb93d571987a3d40c96c6cbfd9244d19b9708ce5aea454"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
    ]

    # Cocoa and SDL UIs cannot both be enabled at once.
    if build.with? "sdl"
      args << "--enable-sdl" << "--disable-cocoa"
    else
      args << "--enable-cocoa" << "--disable-sdl"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("gtk+") ? "--enable-gtk" : "--disable-gtk")
    args << (build.with?("libssh2") ? "--enable-libssh2" : "--disable-libssh2")

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qemu-system-i386 --version")
    resource("armtest").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info arm_root.img")
  end
end
