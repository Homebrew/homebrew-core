class Quvi < Formula
  desc "Parse video download URLs"
  homepage "http://quvi.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/quvi/0.4/quvi/quvi-0.4.2.tar.bz2"
  sha256 "1f4e40c14373cb3d358ae1b14a427625774fd09a366b6da0c97d94cb1ff733c3"

  bottle do
    cellar :any
    sha256 "9e3b86dff84297edec9c63ff1593136c2ce62e8a9f8d523e9d9137943da939bb" => :sierra
    sha256 "c5a8c9b53432e15b4ec31a9c1374bde130d56f73f8ee43e392917a52f34ab945" => :el_capitan
    sha256 "944922426376a9962bb90f032e02ef2404d3155ed3bba81a0b4d349ba1f1aec8" => :yosemite
    sha256 "631889c5bfbfa3741a33efb350b020abaffd163016d375bfa41aedf5cf93262e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libquvi"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end
