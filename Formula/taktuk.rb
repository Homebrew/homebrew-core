class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "http://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/37055/taktuk-3.7.7.tar.gz"
  sha256 "56a62cca92670674c194e4b59903e379ad0b1367cec78244641aa194e9fe893e"

  bottle do
    cellar :any
    sha256 "9cc466f8a75eea1974143fedecd42547eb14401d772e527776f387aec4832f77" => :high_sierra
    sha256 "0ffc0bb09703bbf32afbcd302850803f94ecbb311eaa77353275e7dcb1549f62" => :sierra
    sha256 "4a731d243e6915729240deb75dc99cfee513bb7d0f69169981623b14ce6601c1" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/taktuk", "quit"
  end
end
