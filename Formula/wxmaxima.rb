class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.10.0.tar.gz"
  sha256 "5ec0a912ebe2688b0fbe10999463cb8365ce5e87d8a47eb04f95bd63880dc2f0"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "89b8531a3cecd73bf103578f04b2e53b5cc5989e02d24c078ca0999e5f7bc5fc" => :mojave
    sha256 "32aecb026524a9c7b39dc3b2cf48a5c5085b234be42b8feda5751ac12b8d0130" => :high_sierra
    sha256 "adf3cb6242fb85f561bac2b6491c0f7e40ffcb680487b4d48768af88aaa3c1ae" => :sierra
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
