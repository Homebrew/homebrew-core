class Redstore < Formula
  desc "Lightweight RDF triplestore powered by Redland"
  homepage "https://www.aelius.com/njh/redstore/"
  url "https://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz"
  sha256 "58bd65fda388ab401e6adc3672d7a9c511e439d94774fcc5a1ef6db79c748141"

  bottle do
    cellar :any
    sha256 "a17c99ed5d7162eb742eef7b8764c64082fff26895baa81cb26cb75ced03db5e" => :mojave
    sha256 "fbd9814ed5e35fb1c964d6f581edebfc35e7d35cba0b89ea735247131c5559ac" => :high_sierra
    sha256 "e507eab072e33f0cee1ca08efb51ab06d65cee3a64248ec6badbd4f601f5c674" => :sierra
    sha256 "5ae64e4a536011ef3f68d2e8b4253624f60995025064de38f3a38308dd005421" => :el_capitan
    sha256 "1c891f4297c26269136c5caa5be3ab721cbb8e5b53c83daf3440082df4edf6a2" => :yosemite
    sha256 "55e35fe682d2bfd5b4e13d7e66302d79033766056e55b0031ce649ad582b30e3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "redland"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
