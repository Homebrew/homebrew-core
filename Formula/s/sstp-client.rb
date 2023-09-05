class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.18.tar.gz"
  sha256 "d879f4f35ab7eae87486edc48b50f99a9af65f5eb6fb4427993ca578bb0e0dc8"
  license "GPL-2.0-or-later"
  revision 1
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "4150a77157b10963596842ea5c257b70363cfaba28ac3bfff1f9f6074a47ed9a"
    sha256 arm64_monterey: "6ff8857979b82f4b97457f03a665043bb224e5ad592367146598f66cac391f04"
    sha256 arm64_big_sur:  "1fe3ed11b72387045483883c2924d15b5a25729edec8dc80a3ddab008d8d4887"
    sha256 ventura:        "132b0a1692c51b79a389c0795fcc228fe980a095dcb5d5679fd0b5e106f3951c"
    sha256 monterey:       "53b5a095eae90346d602fd869d866e51ae802996e5e709d48155546896e53ff6"
    sha256 big_sur:        "32ac6352f38629719436d17b75fc28e03d8ddbb9f27710034858da21cc1bd4cd"
    sha256 x86_64_linux:   "5f415ec7085cc1b3a82a5a5746ca5e27417b003753ed7bde514e6ccef9631404"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats
    <<~EOS
      sstpc reads PPP configuration options from /etc/ppp/options. If this file
      does not exist yet, type the following command to create it:

      sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
