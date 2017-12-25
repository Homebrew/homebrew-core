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
    sha256 "0ff3bbd8ad62d9200fc1f84c67207d4d3e0ce0dc95c2745fca49f8ffa0dd4a1c" => :high_sierra
    sha256 "4a77150a0c9b436b32bbb3516595ee392095776d1e0a0492fd49b72c7a0dc9b8" => :sierra
    sha256 "f5d96bb0f0309d4cf28f17b08e572631a9286b30937af0dfacb360825e0de28c" => :el_capitan
    sha256 "799596712549113267edfbffd1ba3c0bf3a0be18face730a8b90cacd1e9653dc" => :yosemite
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
