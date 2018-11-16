class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.0/tcpreplay-4.3.0.tar.gz"
  sha256 "935c9f5483a9f0ffd5a5ad055b6c7be5c14a3bc9023d4e45ec80dd94857ac79f"

  bottle do
    cellar :any
    sha256 "02519ad95fb3934c06b0f3485e8bc1624cc0cf3b57af188eb1f75e03de0650d6" => :mojave
    sha256 "9be61ec3aeeac7be8cd51225d5914a7ba7ee8f0c9fbd4393e452f6b9447a53c7" => :high_sierra
    sha256 "569bdb4ac12e4ff62c723b1fdabad4b037c54423a70742306ba852f9bc43e25d" => :sierra
    sha256 "b5ba1668dddf52946866c866bc1ba2ab2983b67d99c69b6c41fabe91e816139a" => :el_capitan
    sha256 "3eaba6e1af68c8af3f7d1d0a15c2563b178368a74a760e3fafa5b3c4774f9129" => :yosemite
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
