class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ad433f9272fb794aafd550914d24cc0ca33d4652cfd087fa41b911fa9e54be3d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_ventura:  "a1f92979238ce96a9e1dad059c61b915f28fe2af8af61be3c4f01d9bb13b64b0"
    sha256 arm64_monterey: "906099706defaa4b82d070d35cde96b9b716560bf8f29c5f1d18fbd7b2fa847e"
    sha256 arm64_big_sur:  "7b4ca50ae7f28dbdad95b376d69c0c43f1dff3cc95968232fd58267a734eb054"
    sha256 ventura:        "ec02a4188053a686607498eefbd7534ea17cc899f212e3c8c430c3ede788c30a"
    sha256 monterey:       "63a28803f336a0d14afae5d9a541a2662ca731e6e951fb2f5d09b55037627022"
    sha256 big_sur:        "a71339943c70c494e10817a86af73a0a9f46b1d7b95bc01ef0713a4ed6fed820"
    sha256 x86_64_linux:   "82fa70aa54fc95945c71a9714302fd0140dd19b741e0cbd8c093ce521c6bd3d3"
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
