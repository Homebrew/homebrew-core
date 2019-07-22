class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  url "https://github.com/LibVNC/x11vnc/archive/0.9.16.tar.gz"
  sha256 "885e5b5f5f25eec6f9e4a1e8be3d0ac71a686331ee1cfb442dba391111bd32bd"

  bottle do
    cellar :any
    sha256 "388752257323e1376251e32dea385830afd3a11215b3661dc928111442cb2b5c" => :mojave
    sha256 "3ed573fd3d02c34f407858af3f6e01386d1af2fc9fee16258eea94a4b2c19137" => :high_sierra
    sha256 "3f840749807f57b4248c9ae202a214209c4bf4c4e7386d47da83b424153abe2a" => :sierra
    sha256 "f4a33301592ef159be8f999fce086875bf88afd6ad2b48d6709c2f32d4ab3be1" => :el_capitan
    sha256 "38e07e6c3a26cf1e8d60f1a4e7061da400afb9bb2803f0dd79566c5a3bfd0d22" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libvncserver"
  depends_on "openssl@1.1"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@1.1"].opt_lib/"pkgconfig"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --without-x
    ]

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    system bin/"x11vnc", "--version"
  end
end
