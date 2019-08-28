class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 6
  head "https://github.com/tats/w3m.git"

  stable do
    url "https://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs
    patch do
      url "https://deb.debian.org/debian/pool/main/w/w3m/w3m_0.5.3-37.debian.tar.xz"
      sha256 "625f5b0cb71bf29b67ad3bb9c316420922877473a6e94e6c7bcc337cb22ce1eb"
      apply "patches/010_upstream.patch",
            "patches/020_debian.patch"
    end
  end

  bottle do
    sha256 "571d0562f50fb42eab8fc7efd03e7d3be1418ffdcbe378d2501ba3f53593e650" => :mojave
    sha256 "74830829e5e3de7ac58b7486a2a8371ba2ea340d657d46693fc16e9db8c7ee34" => :high_sierra
    sha256 "2d71608f1489de2eea58f1246d54f9cda56ddb94b7f1cd6652af3527823d64de" => :sierra
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
