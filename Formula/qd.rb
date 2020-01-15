class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.22.tar.gz"
  sha256 "30c1ffe46b95a0e9fa91085949ee5fca85f97ff7b41cd5fe79f79bab730206d3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "381d4980019ee68eb91b62aeea98bc75d481597ec69c05b2d3790eda84b2d979" => :catalina
    sha256 "686b9051338bcc167bf940beb8d6fbde45a47d5a9051ae61c80567ba998f35f8" => :mojave
    sha256 "669c57dbb78a65de4fb0001ea0ad5e6a95d506bdf3651d38880901ef691659c3" => :high_sierra
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
