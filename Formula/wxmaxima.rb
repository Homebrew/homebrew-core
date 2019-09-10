class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.09.0.tar.gz"
  sha256 "5080cc3fee1bd1fb570dd354dea3c4fae8e8b752895e720fd51e160481d2bd72"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "e56fb2634376e8f5b0d210b3d35f41ebeb6efc721f798d9a037ac3fb82c98fcf" => :mojave
    sha256 "90206d0b1ae9ecd436f79b9a9a24f6c25ad34bd6bff8f083ccdbfcdbf93e3c0e" => :high_sierra
    sha256 "05afed0a5f13840a11eed5b9d6d3bc5564194631bf909b4dc9b5e218a0ec216a" => :sierra
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
