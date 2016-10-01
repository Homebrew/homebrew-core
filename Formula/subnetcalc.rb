class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.4.tar.gz"
  sha256 "e46a6f8d5e6f91ce50e710dc08a9079979899c26a2b22c2e033eb4f950b8fecc"

  bottle do
    cellar :any
    sha256 "2d2eb47734e58bb15d737336d74e21829e6b73506c38060e77070b93a407a934" => :sierra
    sha256 "e5c7229e2be576443d373b274d8b24e8a3d4820e520469d4f891dceff18e795d" => :el_capitan
    sha256 "57248f88bf4f9031fd162878a556115e150d65c9b52d7d3871b0eba44da2750e" => :yosemite
    sha256 "95cc39715a9bcd2cb46f7daf974f2e4b31810052b61b38be196a51f136d6aa28" => :mavericks
  end

  head do
    url "https://github.com/dreibh/subnetcalc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoip" => :recommended

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"]
    args << "--with-geoip=no" if build.without? "geoip"

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
