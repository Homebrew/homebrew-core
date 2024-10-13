class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9679ca171e8aaa3c4e4053e8bc1d10c8dabf0220bd4b16aba78743511c25f731"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia:  "e2c4bd0e4caeae9b7eca2c6194c45049484dc149056c3c594e40a53f7e06a044"
    sha256 arm64_sonoma:   "726b2d08394252d97179fbd3ec31bb3ec36ec8a5c0da9f766eb69be2f8ee0e6b"
    sha256 arm64_ventura:  "18485cb18590d95725ea35cb7e4e1b23d39f464a9b6a2e4a6c5ace343c95d6a5"
    sha256 arm64_monterey: "1e6e7565a5be8e020c9520d58eb00126c2c4825003fbf1cda1ba552e71d1162a"
    sha256 sonoma:         "fa3c8e6fc64926c88359f48ab4923dcad77bd2fd34b88c7efc8fd609c7382ab4"
    sha256 ventura:        "bdf86130622d7c291eb7cfc18e12fdfa74494b3c5727f04f102d47588eb13496"
    sha256 monterey:       "eb37ade00357e2e6509d142262d0fcd7cee755a1c4e221aabc821e728d3546ff"
    sha256 x86_64_linux:   "9a9920cd1b18dbe4ad05243c70d597423b4360573076c3ee43a30c78c2e1ea08"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
    system "./autogen.sh", *std_configure_args, "--with-openssl"
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    pid = fork do
      system bin/"swtpm", "socket", "--ctrl", "type=tcp,port=#{port}"
    end
    sleep 2
    system bin/"swtpm_ioctl", "--tcp", "127.0.0.1:#{port}", "-s"
  ensure
    Process.wait pid
  end
end
