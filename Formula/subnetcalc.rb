class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.8.tar.gz"
  sha256 "bb99c5e20e1f1861913d0747e32fcd9f174f674a723b5c255f44b7b43754ae09"

  bottle do
    cellar :any
    sha256 "c730ad755d22afd5e2fd2017910c4d69d693813fb632d761ea52992847b47f88" => :high_sierra
    sha256 "29f37e42624b4fb437bf7795c0341f3b1b2e31dcf025b796b6a198532c21ba4b" => :sierra
    sha256 "5d90401c8ef320206a3479945b536c0dace81e1c18bfcd3ce67d418fea059b55" => :el_capitan
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
