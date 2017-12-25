class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 2
  head "https://github.com/tats/w3m.git"

  stable do
    url "https://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs and provides openssl@1.1 compatibility.
    patch do
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/w3m/w3m_0.5.3-34.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/w3m/w3m_0.5.3-34.debian.tar.xz"
      sha256 "bed288bdc1ba4b8560724fd5dc77d7c95bcabd545ec330c42491cae3e3b09b7e"
      apply "patches/010_upstream.patch",
            "patches/020_debian.patch"
    end
  end

  bottle do
    sha256 "2f74b9e77dc894a6fe989f94125e6f85707d33e395c9d6b62fe7018b9639b13a" => :high_sierra
    sha256 "e83f9f082df3a1650d334feb396f4e4425939dbb43d95b07d5dc10182ea7432e" => :sierra
    sha256 "3f19792501aace857717543b719827e3a2227ce1bb917c7abb2f20e9db7a4c54" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-image",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match /DuckDuckGo/, shell_output("#{bin}/w3m -dump https://duckduckgo.com")
  end
end
