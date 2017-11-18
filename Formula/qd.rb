class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.18.tar.gz"
  sha256 "81096b5b33519cbeed5fc8ef58e1d47ee8f546382514849967627b972483716e"

  bottle do
    cellar :any
    sha256 "d38cb453d92a16e57f3b070117bca8fc6f9af3bfb80f9a4e6e09755c1ac803fe" => :high_sierra
    sha256 "473b459248304ec63dbaed62c345273e9625b64c0b654226e97c3a48b699ceaa" => :sierra
    sha256 "5e2f24e0bf506991d3e962bcffafbd608f0c3ff812fb71214f27f18e63eb9da0" => :el_capitan
  end

  depends_on :fortran => :recommended

  def install
    args = ["--disable-dependency-tracking", "--enable-shared", "--prefix=#{prefix}"]
    args << "--enable-fortran=no" if build.without? :fortran
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
