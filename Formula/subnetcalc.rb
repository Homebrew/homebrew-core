class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.9.tar.gz"
  sha256 "dce27b53857625fdec0409b6534f89eb573d19cc2928ef6d81845902a759cbe9"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any
    sha256 "5ae7f6d094951ba6dc5e8e8eac37536bd2b5abdef11b32cb0c76fe105f99647e" => :mojave
    sha256 "56552b16e0c1326eb508d13af9bdab59709670b25082ec837d3334fd497c45bf" => :high_sierra
    sha256 "bd9806c0f81f3e29c698d170bfe98e43d1c74f0cd88cc2de4511a67dee807c5d" => :sierra
    sha256 "424750f2fe1b78f72dc87becbb0310fe82afe0e6797ab30195ac15c1462b56a4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
