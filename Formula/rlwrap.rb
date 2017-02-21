class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/v0.42.tar.gz"
  sha256 "fff56c24341f0c717cf3a8f0ebbf2cba415b1952e1591168ca69ed13638b20f3"
  revision 1

  head "https://github.com/hanslub42/rlwrap.git"

  bottle do
    sha256 "53859da22797c6c4b51754b538dc4be18866f492bbcd14c66228ee1f7d11a93b" => :sierra
    sha256 "1361a917ac884c5d9f2755ec08b33f5ce57e68687a5f19458a2c0854dbdc6da7" => :el_capitan
    sha256 "48b56717c9b66c9c56e288b5e9dca32b5c3f6a256c5b3057f68f46b920788e59" => :yosemite
  end

  depends_on "readline"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-v", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
