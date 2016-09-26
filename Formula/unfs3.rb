class Unfs3 < Formula
  desc "User-space NFSv3 server"
  homepage "http://unfs3.sourceforge.net"
  url "https://downloads.sourceforge.net/project/unfs3/unfs3/0.9.22/unfs3-0.9.22.tar.gz"
  sha256 "482222cae541172c155cd5dc9c2199763a6454b0c5c0619102d8143bb19fdf1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "39efb568edcd8eb1898deb664c1f016baed60b60cb9d6031743da32b6f615cd3" => :sierra
    sha256 "b1387de21ce9672d5caea47ff223fdbca37e0ed08137a252ae14c7c80dea36e1" => :el_capitan
    sha256 "8daaa9ce7c48d3a0efbf72dac2e7cdb429aa7aa8475b64837eaa4f5159b2a4d8" => :yosemite
    sha256 "43e89011e0472b5a7aea6583f930d05d18a449474617f5d11b10b10b52badc66" => :mavericks
  end

  head do
    url "http://svn.code.sf.net/p/unfs3/code/trunk/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.j1 # Build is not parallel-safe
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
