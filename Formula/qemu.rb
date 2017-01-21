class Qemu < Formula
  desc "x86 and PowerPC Emulator"
  homepage "http://wiki.qemu.org"
  url "http://wiki.qemu-project.org/download/qemu-2.8.0.tar.bz2"
  sha256 "dafd5d7f649907b6b617b822692f4c82e60cf29bc0fc58bc2036219b591e5e62"

  head "git://git.qemu-project.org/qemu.git"

  bottle do
    sha256 "9b14fea7d0151fd7a150678b4328d05fb74d75e66613733ba5dca6b1cbb2c1e3" => :sierra
    sha256 "5d828daa16ec27a62509bae002f35ffd6135905dff5ade78de81479e6dada346" => :el_capitan
    sha256 "d6229727ed1d48b67b8308d093c4238b3cd3e5e56e4e0994794be7b7168b0b62" => :yosemite
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

    # Fixes "dyld: lazy symbol binding failed: Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace %w[hw/i386/kvm/i8254.c include/qemu/timer.h linux-user/strace.c
                   roms/skiboot/external/pflash/progress.c
                   roms/u-boot/arch/sandbox/cpu/os.c ui/spice-display.c
                   util/qemu-timer-common.c], "CLOCK_MONOTONIC", "NOT_A_SYMBOL"
    end

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
    ]

    # Cocoa and SDL/GTK+ UIs cannot both be enabled at once.
    if build.with?("sdl") || build.with?("gtk+")
      args << "--disable-cocoa"
    else
      args << "--enable-cocoa"
    end

    args << (build.with?("vde") ? "--enable-vde" : "--disable-vde")
    args << (build.with?("sdl") ? "--enable-sdl" : "--disable-sdl")
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
