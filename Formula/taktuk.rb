class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "https://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/37055/taktuk-3.7.7.tar.gz"
  sha256 "56a62cca92670674c194e4b59903e379ad0b1367cec78244641aa194e9fe893e"
  license "GPL-2.0"

  livecheck do
    url "https://gforge.inria.fr/frs/?group_id=274"
    regex(/href=.*?taktuk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d33ad42f68016a53bbb84cfdf5704cae271041ada4b42c5b3892d30ff76e479e" => :big_sur
    sha256 "d9743ff8c715d03d4549f09850a2029c135e72859d0518d94b44b3aa51f7abf6" => :arm64_big_sur
    sha256 "7ed3f1542b9acfc2ad2de0b9150ad4e7aa72246415be9046fe5eafaf794b478d" => :catalina
    sha256 "6ff23461c51c77612a5c00fc4caf40d9c91aa3e7b2f409e9a86f57f27f305f01" => :mojave
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
