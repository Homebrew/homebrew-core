class W3m < Formula
  desc "Pager/text based browser"
  homepage "https://w3m.sourceforge.io/"
  revision 1
  head "https://github.com/tats/w3m.git"

  stable do
    url "https://downloads.sourceforge.net/project/w3m/w3m/w3m-0.5.3/w3m-0.5.3.tar.gz"
    sha256 "e994d263f2fd2c22febfbe45103526e00145a7674a0fda79c822b97c2770a9e3"

    # Upstream is effectively Debian https://github.com/tats/w3m at this point.
    # The patches fix a pile of CVEs and provides openssl@1.1 compatibility.
    patch do
      url "http://mirrors.ocf.berkeley.edu/debian/pool/main/w/w3m/w3m_0.5.3-34.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/w3m/w3m_0.5.3-34.debian.tar.xz"
      sha256 "bed288bdc1ba4b8560724fd5dc77d7c95bcabd545ec330c42491cae3e3b09b7e"
      apply "patches/010_upstream.patch",
            "patches/020_debian.patch"
    end
  end

  bottle do
    sha256 "31d0388967c3a448cc0c27571e3976cbcf79bad9986000adcff74428afff587a" => :sierra
    sha256 "c6443287699a058e58ff0e378a8f6459370de79f89246ac7217e11f9f748abed" => :el_capitan
    sha256 "57a644921789316e92cbc37d2e0c51eaf5591876992626a9bcf9f4a56c0e3897" => :yosemite
    sha256 "e2972a26e7c734e6814257516ebda796e907df5787906c4144321fc63e70f1a1" => :mavericks
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
