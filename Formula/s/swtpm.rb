class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "b281b4e8c39f68e1928675f788abc70072e4081152e129144359a8c5c304c06b"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "20e13841f168cb9aef6fc6f22f6179087fc4d68bff065b2c15863fe2f6cfce26"
    sha256 arm64_ventura:  "6bf7f54c1532d4a14a2f4b210aeca4cb4749b642e39637cce1b749b5b324500d"
    sha256 arm64_monterey: "dd61348ec16bc6a6479a0d1520af5c48312a964dd10fa90d1f85ad578da433a7"
    sha256 arm64_big_sur:  "d5c938d7e41d4ff9e1eaabe10536e7cc1b0493660d0bd1b80479e3e14f9f7b76"
    sha256 sonoma:         "41ff4352e11dca25d43789db11a887490107351f559f5d42f5d486465b4597ea"
    sha256 ventura:        "c023e0cc4da956913cd6cc945846c3c514eac0111b801b5f8f332bcd850a3277"
    sha256 monterey:       "b106e386bcc25ef4f3f3157c5227d1d8ddd07d3da66a817699b987c8c166fcc1"
    sha256 big_sur:        "1c199f5dd2b71c10663900633c6f990cb8b94e59e8bb0020dc8bc18361ee3bdd"
    sha256 x86_64_linux:   "867a9a8dd72a24aa10930b7e838848efdac7d5b1bd9448c38c9f34d9cc0e71cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "socat" => :build
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libtasn1"
  depends_on "libtpms"
  depends_on "openssl@3"

  uses_from_macos "expect"

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
