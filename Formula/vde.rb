class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://vde.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vde/vde2/2.3.2/vde2-2.3.2.tar.gz"
  sha256 "22df546a63dac88320d35d61b7833bbbcbef13529ad009c7ce3c5cb32250af93"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/vde\d*?[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "e4d5fbb28025cb50acf1a1c8e11a2aeb33e1324b42b49d7f3709fab81a708c55"
    sha256 arm64_big_sur:  "d504166629275fb173304ee78b134a6c5b5eabba65c054f2fede1949204382dd"
    sha256 monterey:       "c043ada3aefd2f0a9eeb6f60db1003cc6b340da282d7fb93d940be47aac9fc6b"
    sha256 big_sur:        "f634d3558c44876138a229f06554ab603b31e412a03c049d96f6c3616e579729"
    sha256 catalina:       "711f5b171e033b92505178b35a324a5c21e806ed5054a92ef02f26b3a38a760e"
    sha256 mojave:         "4f880ec345fe86fdfcfc53468c7c24d160261a17ee71a289ea3357a47b71416c"
    sha256 high_sierra:    "79ee1bbcca1f873e3740db401c1f8735f2366e785b56fcf6e0e4140e9048333b"
    sha256 x86_64_linux:   "d0ecff46c013cef96a1a32d6fd45d415a32dbd300932d2eb352f969445ce251c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-python"
    # 2.3.1 built in parallel but 2.3.2 does not. See:
    # https://sourceforge.net/p/vde/bugs/54/
    ENV.deparallelize
    system "make", "install"
  end
end
