class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.2/tcpreplay-4.3.2.tar.gz"
  sha256 "4f479bd9196cafde70c58ab072ca4959ecc5278555cf1aa7cf42f7f210daa951"

  bottle do
    cellar :any
    sha256 "13eb5d7675349a7840d4cd925718fce267df8d9cacc270ae3968d9fbdd974aed" => :mojave
    sha256 "f878a29cfa13475e768d9dcb36f2939810eb5ee05a20add2a8520bebf1a9720f" => :high_sierra
    sha256 "160b57832d9edbfb3944534c32bb6c86d08937cd2d816418b7c6dad2ca739c9d" => :sierra
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
