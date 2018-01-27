class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 5
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
    sha256 "d22255d52e3655ee569eb9f10148c3c252348f0110aebdd9ad4674535a2abb96" => :high_sierra
    sha256 "253aa174cda21e291fb62936c6df64de6fedfa42c4889b3cde961767d2230c64" => :sierra
    sha256 "38bbff9a83da585bcceba8a70e69b5abf3dd84ab75b62da090e49f8e6cbad46a" => :el_capitan
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
