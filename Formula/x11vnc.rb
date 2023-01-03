class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "https://github.com/LibVNC/x11vnc"
  url "https://github.com/LibVNC/x11vnc/archive/0.9.16.tar.gz"
  sha256 "885e5b5f5f25eec6f9e4a1e8be3d0ac71a686331ee1cfb442dba391111bd32bd"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "38324f98f26ae2449c4a6ff17618419edaff6d4bbf9121a72b8148259f86969f"
    sha256 cellar: :any,                 arm64_monterey: "0524eee07eea63fba0608c0b883833d1eaef6968fadeff0a8e9484ecd876b310"
    sha256 cellar: :any,                 arm64_big_sur:  "2a31e43f659772fbeb91cc08be809a70999aaab08855fac54cc62f4620704532"
    sha256 cellar: :any,                 ventura:        "46c01ed3a37614e6c672c704c47d678295b85aedad46a469ac7bd3ec89426efc"
    sha256 cellar: :any,                 monterey:       "5daffa352af06684f3667150491916bf42ed671e0ded33d4b94db65eaf324781"
    sha256 cellar: :any,                 big_sur:        "e657f9d340736e450eebf51336c42f180464e91b179e3ca289eedd5131cf62fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44a30e51f3ae1de8c80e9b4c3ab492fe22242db0b99e1cc7b5f578839accec4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libvncserver"
  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: x11vnc-xwrappers.o:(.bss+0x440): multiple definition of `pointerMutex|inputMutex|clientMutex`
    ENV.append_to_cflags "-fcommon" if OS.linux?

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
