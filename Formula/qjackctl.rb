class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.5.1.tar.gz"
  sha256 "446f1ddc3d75b48462da3a467293a49a72c8a89063cbd6b4b75d620231d1814b"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "069d8a4e715e0b1c3c54c763ca0ecd8dcb506b01ee9fe30f0a231766b4d601b5" => :high_sierra
    sha256 "f776de566a4308d23ea9a6e9b1ca659fc7d775c81db1fa5224dfa7044c4a47db" => :sierra
    sha256 "c1df5a396134f2d13c9dc456cd2ce1ed8b9fb71b7120bcd02e5ae98c5b72932c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "qt"
  depends_on "jack"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt5=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
