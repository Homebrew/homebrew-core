class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.3.4/tcpreplay-4.3.4.tar.gz"
  sha256 "ee065310806c22e2fd36f014e1ebb331b98a7ec4db958e91c3d9cbda0640d92c"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    sha256 cellar: :any, big_sur:  "c089911edcc55dc9126528b5843358a7b748bb4d0ef155812f84b097c5a6df08"
    sha256 cellar: :any, catalina: "ffe406994fdd18db4219b9a96908cd49c76dda59b7b6d6a0e7e27acc04d5f046"
    sha256 cellar: :any, mojave:   "f55a4af6cbc64fcf75fd5967ae13f9babd24472c4f1ce659beeaa8754a317fda"
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
