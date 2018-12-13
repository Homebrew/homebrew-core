class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-18.11.4.tar.gz"
  sha256 "6a2931a14b9491fb0900cf6127943c6f596ed97bb560f1e84c95303909a1fa71"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "02c4a16d06448ab1410ff7fec65915f59bd1f3485b725a6ec4a92b8800dfc23f" => :mojave
    sha256 "9013958a921a67e2762cc8434722d2fe53ac325dfd484ac461d1fc19aa4dc291" => :high_sierra
    sha256 "eae8c1b5b04d6d166fd91ce7444047717f50660150fcc91b0dafc71365a6fac3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app"
  end

  def caveats; <<~EOS
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
  EOS
  end

  test do
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1", 255)
  end
end
