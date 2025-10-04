class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f8da11cadfed27e26d26c5f58a7b8f2d14d684e691927348906b5891f525c684"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "a461f024f4030423eaab2f9708d31ce40abed33ecacf79af52eed9c30685954f"
    sha256 arm64_sequoia: "2b32d468bbe362aa59c40e0ca09cd222bff2e7ad0926f254805ff4988c0ee0a8"
    sha256 arm64_sonoma:  "bde6abef0af8f822719577619263e1f733d66fa8a6da8d5cc32fc08207bfcc0f"
    sha256 arm64_ventura: "480984d30dc4d4dc8cb88e6c7e7c71061bc4f931a8185465e13857b25129f47b"
    sha256 sonoma:        "a784a5c3d7c831a4cc8715451633570f55666e9436628a8458b34bf7e2275fd2"
    sha256 ventura:       "8d49a8ca6833ae9af931a695bda0db32830abf0cdaf0938037efea28557c5952"
    sha256 arm64_linux:   "ea07d63f7e38a8724096a357f6bbc9cb2c16eb0cb8c3cba501d2bc0c77569370"
    sha256 x86_64_linux:  "a289daeb82cb654710fbfe43b9bd3d2f80a2eeee1c7f20d7d5481e7a3f1c1d3b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "socat" => :build
  depends_on "glib"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libtasn1"
  depends_on "libtpms"
  depends_on "openssl@3"

  uses_from_macos "expect"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libseccomp"
    depends_on "net-tools"
  end

  def install
    system "./autogen.sh", "--with-openssl", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn bin/"swtpm", "socket", "--ctrl", "type=tcp,port=#{port}"
    sleep 10
    system bin/"swtpm_ioctl", "--tcp", "127.0.0.1:#{port}", "-s"
  ensure
    Process.wait pid
  end
end
