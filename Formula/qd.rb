class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.20.tar.gz"
  sha256 "72900ae5d3047719624701878abd8ed88fe3e4bc844c6fd614161ad926518385"

  bottle do
    cellar :any
    sha256 "37b044703d09d11200e23d45a138649dbba9c8876579bfc3201c26c35579e818" => :high_sierra
    sha256 "b3b9f5d238ffdd8b8992e2f6be9396666bb41650a5697261b197df5b0782d147" => :sierra
    sha256 "f733c61c8c22c46091fd6007fc555bc53b02adc8f625ed33f5ca56a049ab9c01" => :el_capitan
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
