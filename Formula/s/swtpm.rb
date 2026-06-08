class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f8da11cadfed27e26d26c5f58a7b8f2d14d684e691927348906b5891f525c684"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9a60d0e6adebb8d733ebf8d8513adfea86794e8fa69cc8f26bdcbbc13bd789c3"
    sha256 arm64_sequoia: "8f798f1a861ba329fb30c2183f369d5a59b6511af160ac49a9daa0d4b1cef746"
    sha256 arm64_sonoma:  "806ee9bb517067c3969f8877cc59bcfa18bbf5dfb90c1e2c46aa153462e9c5d3"
    sha256 sonoma:        "c08557ef9d9cd1b03c3af01f03d58715ad9f708460149ed800c124956b8c6482"
    sha256 arm64_linux:   "a51c9b172f794b7e95b102a6f637f4eb655682e58af37d13a17970e7e7985a31"
    sha256 x86_64_linux:  "45c2a54bd1d006b674542e4082856783c76fba8260f678951df0bc2b5bdc8a01"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "socat" => :build
  depends_on "glib"
  depends_on "gmp"
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

  # Backport changes to drop GnuTLS
  patch do
    url "https://github.com/stefanberger/swtpm/commit/86c6046cbe0e913e884683d20acec3949a4a1220.patch?full_index=1"
    sha256 "8f0c469d178004128c97645f4bb849355473ad0181d6063c6dc5ba1565b716a0"
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
