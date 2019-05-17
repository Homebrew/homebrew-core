class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.22.tar.gz"
  sha256 "30c1ffe46b95a0e9fa91085949ee5fca85f97ff7b41cd5fe79f79bab730206d3"

  bottle do
    cellar :any
    sha256 "219d016113bc23c78c0d41e5e8348bca0513a1c58aa3f3b3c589c60bb5543a5d" => :mojave
    sha256 "d5b003dd1d1fcfb17072ee7c7dcaea5509b9560c76fa9dd70a8777abf4c109db" => :high_sierra
    sha256 "ddf703320eaf12c61779886cdbb4aa6c1035528c6ae09f193bd2f6fcd8737a25" => :sierra
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
