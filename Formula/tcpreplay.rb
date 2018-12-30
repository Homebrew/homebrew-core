class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.1/tcpreplay-4.3.1.tar.gz"
  sha256 "95ba661011689a4a6c03896ba7fa549470c2c2d4d0e907dd0c4a4580bbe25e34"

  bottle do
    cellar :any
    sha256 "7a3f711ee3bcc546a0e4b6c0395996f0f2c40467911ca2340361391ad898817d" => :mojave
    sha256 "a38dbba8d5d0fbf76af86798e5e2135109d802d3059efe7b2684ef005d58e6da" => :high_sierra
    sha256 "6cd6954e49a836ea41ff3e47cdd7dd7e987178ce4a500b734ab2f7b65b289a12" => :sierra
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
