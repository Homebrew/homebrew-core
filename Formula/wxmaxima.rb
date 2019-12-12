class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.12.1.tar.gz"
  sha256 "ce37361141821ce58cd3be5c316c40a8f19b741eb20c936d86152bfae1f101f5"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "6538212a18e24c5450ab5c78054089b22ae96b0affc58df57da435ca6463c0a4" => :catalina
    sha256 "9045f4071191fdc2ab09f5c930f43251abe29d8ebb5e944f28574e651953830d" => :mojave
    sha256 "7107a38f3a94689606f75d5d956af91c181d917ec580a7359eeed552a61bc37e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "wxMaxima.app"

    bash_completion.install "data/wxmaxima"
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
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
