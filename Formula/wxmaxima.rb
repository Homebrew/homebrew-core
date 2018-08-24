class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-18.02.0.tar.gz"
  sha256 "727303bd26bdc7eb72dea0b0fcfa60c0180993430d55a4e3700c92eb5e16790e"
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "c9d3d8af90adaa844bd47709ca0e1aafb9bfc879c50281f918c1051d3f565264" => :mojave
    sha256 "1cab5b45e11c9a53b04e88e49226d2e9eb0965f1367c86ad30915694cea1eba6" => :high_sierra
    sha256 "b44af0b7c1a8aac7d5a5270eaafa9d21c1d3e84940784e6fe343860d9b1eefbd" => :sierra
    sha256 "f742fa1359c964822066034bf08d7a454e5d73546e2138f63deb4de79ae5c9d6" => :el_capitan
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
