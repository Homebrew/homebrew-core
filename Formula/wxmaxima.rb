class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-18.02.0.tar.gz"
  sha256 "727303bd26bdc7eb72dea0b0fcfa60c0180993430d55a4e3700c92eb5e16790e"
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "8f80844c94e38e0e405a274aec094b7f9aea238762703639790de8e2de3280f2" => :high_sierra
    sha256 "d4173dbf5d8d08e94b6ff9b39fc6eb88aaa57e309a1c6e8f93310a0ea9c09bae" => :sierra
    sha256 "62be362ff5d80cd7334fdb00e4b71aa24e4cf65d560e54861e70196e1e9fdddb" => :el_capitan
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
