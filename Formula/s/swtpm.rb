class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "f61cf6f1e9bbcb4cefb30b70cafaf1c4df54c6961e65cfa63830e8ad0e220134"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "7c061c6f76ae1ddac24748f1b1ec3a421ed9b5419a190f64b77d5c6dbb44978f"
    sha256 arm64_sequoia: "3c0a94003525270a225ad7c92caad295005cb1022656eef611e1d3308f6bc4d7"
    sha256 arm64_sonoma:  "2c35a122e5c9f031d9665fbcc5767ed26642897a780d4f26801401dd9c892379"
    sha256 sonoma:        "b5772c37534f67b52b627875152a12d42763d73ef033a70f9681e5fc37d3e80e"
    sha256 arm64_linux:   "49d2065659915890b1f20a852f5c23a6c206f48f41a7b10448dccbfdb83444c3"
    sha256 x86_64_linux:  "5c45c9ffb823f66bbf15839301cf2cf11ca06220144009f301200bfab8f49867"
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
