class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.02.4.tar.gz"
  sha256 "d47ca52e40491ea3c4ea7bea126f4da4d0b535702126abef0c172f69ba58e17d"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "6019f1d7ae87ce5dc27d5c6ccfcf5d0c3d8348453aae491bbdd1d8f73bc2fe16" => :catalina
    sha256 "ce20fe9da4278fd3e9c5c0baecfcf14fa743d41d8ead0696014c11176370b361" => :mojave
    sha256 "ee835e1da326394c5496294c6ed8dc460ded698d461bb6ef5c7976ea427cdae6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "src/wxMaxima.app"
    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima"

    bash_completion.install "data/wxmaxima"
  end

  def caveats
    <<~EOS
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
