class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 4
  head "https://github.com/tats/w3m.git"

  stable do
    url "https://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/w3m/w3m_0.5.3-36.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/w3m/w3m_0.5.3-36.debian.tar.xz"
      sha256 "e7f41ac222c55830ce121e1c50e67ab04b292837b9bb1ece2eae2689c82147ec"
      apply "patches/010_upstream.patch",
            "patches/020_debian.patch"
    end
  end

  bottle do
    sha256 "12da9937b9aa6b5c949dd4e3564a39794b113fdd85d4e0482b36c58e2d51c8bd" => :high_sierra
    sha256 "20013204c45e71e6b130152648f284a75f9074bf12d6dde0a5e7f12417213fb5" => :sierra
    sha256 "f393fb66f5b123ed6d1e9ffb9c6d586265d29e45ed43728cbd8dc3c72d7e7eb7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-image",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /DuckDuckGo/, shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
