class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f61cf6f1e9bbcb4cefb30b70cafaf1c4df54c6961e65cfa63830e8ad0e220134"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "481e1daf351c3210c7d4109bdf0841c0703ed16b2b7992a069555eaa4a8d8f71"
    sha256 arm64_tahoe:       "13c155af6c66a83912f24c667c397c427faa0176cbb6036eff43b8790b52ebcf"
    sha256 arm64_sequoia:     "8fe633a43a2cbd25cd05a6d7b0bfcc03917e2da3ff3ac01ff6f5be8a7d953085"
    sha256 arm64_linux:       "2e823e9e2c09d4ea33d23e557c6db6725678b7862be4dc6736935d9064edd76d"
    sha256 x86_64_linux:      "bfeedebd02a0b0665792d725e33a898c0cd3272b8260e58587a409612722a5c4"
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
  depends_on "openssl@4"

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
    type :backport
    resolves "https://github.com/stefanberger/swtpm/pull/1094"
  end

  allow_network_access! :test

  def install
    system "./autogen.sh", "--disable-tests", "--with-openssl", *std_configure_args
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
