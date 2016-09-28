class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "http://utopia.knoware.nl/~hlub/rlwrap/"
  url "http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.42.tar.gz"
  sha256 "5a70d8469db9d0a6630628f2d5d2972ad16c092400b7fbbdf699693ec0f87e44"
  revision 1

  bottle do
    sha256 "53859da22797c6c4b51754b538dc4be18866f492bbcd14c66228ee1f7d11a93b" => :sierra
    sha256 "1361a917ac884c5d9f2755ec08b33f5ce57e68687a5f19458a2c0854dbdc6da7" => :el_capitan
    sha256 "48b56717c9b66c9c56e288b5e9dca32b5c3f6a256c5b3057f68f46b920788e59" => :yosemite
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
