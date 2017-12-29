class Quvi < Formula
  desc "Parse video download URLs"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.9/quvi/quvi-0.9.5.tar.xz"
  sha256 "cb3918aad990b9bc49828a5071159646247199a63de0dd4c706adc5c8cd0a2c0"

  bottle do
    cellar :any
    sha256 "10fe26a54bcdf8e33e9798b399a3a72e8b571c9668e4398a3f8d1a7952f9c652" => :high_sierra
    sha256 "9e3b86dff84297edec9c63ff1593136c2ce62e8a9f8d523e9d9137943da939bb" => :sierra
    sha256 "c5a8c9b53432e15b4ec31a9c1374bde130d56f73f8ee43e392917a52f34ab945" => :el_capitan
    sha256 "944922426376a9962bb90f032e02ef2404d3155ed3bba81a0b4d349ba1f1aec8" => :yosemite
    sha256 "631889c5bfbfa3741a33efb350b020abaffd163016d375bfa41aedf5cf93262e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libquvi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end
