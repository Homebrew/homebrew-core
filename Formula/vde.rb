class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://vde.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vde/vde2/2.3.2/vde2-2.3.2.tar.gz"
  sha256 "22df546a63dac88320d35d61b7833bbbcbef13529ad009c7ce3c5cb32250af93"

  bottle do
    sha256 "a0cf184ec7804a4984607e3e7d311395514390235241d7844e31aafeb40d48cb" => :mojave
    sha256 "49241bcf4445833cedd86c3d8901e563032874f9976a21a106073760a5095e39" => :high_sierra
    sha256 "3e9215e631197e75b179f9f33bc27483ead1d2ce8b3875b7846cc2568cfe67c2" => :sierra
    sha256 "97989b0577f7a1fbd13c916aff1e61391cf3d7b886c4ef965f0b765e034c8bbc" => :el_capitan
    sha256 "5ca4100e3dae3df4704e2fdf9ae07a1fb0637d2cb2e916e7db931a4cb84a0c55" => :yosemite
    sha256 "ab336b6d84a03dd981d70ab8b377ec3a61dcb9abfffd233c84a0e74c8fadc8b8" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    # 2.3.1 built in parallel but 2.3.2 does not. See:
    # https://sourceforge.net/p/vde/bugs/54/
    ENV.deparallelize
    system "make", "install"
  end
end
