class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.02.4.tar.gz"
  sha256 "d47ca52e40491ea3c4ea7bea126f4da4d0b535702126abef0c172f69ba58e17d"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "97570089b79f6f6bdcc58fe7531aa06b8d3db3ddde7b0b95f54f3e7b253a7401" => :catalina
    sha256 "93b3b7e268e64f97e060b2ffec3f25c024513591d42aff9e8263743cf28d4b31" => :mojave
    sha256 "15532adf6504284586100aa133b20e43ac030db6d241a5eda0f788224a217e4a" => :high_sierra
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
