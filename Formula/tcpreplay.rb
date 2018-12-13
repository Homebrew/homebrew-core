class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.0/tcpreplay-4.3.0.tar.gz"
  sha256 "935c9f5483a9f0ffd5a5ad055b6c7be5c14a3bc9023d4e45ec80dd94857ac79f"

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
