class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.01.0.tar.gz"
  sha256 "f28dfc9a717e4a91446cddba0e010c4383a3e973a11889948bd65ea311df28fc"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "f5a15066c3fd57ca50ded8ffd4cfa12a3682b4b10ac91a662335db7393984b34" => :mojave
    sha256 "18a9745082353eb1d965c6b8bf7d05933dda1003e9c0bd20271c6308e00d0ea0" => :high_sierra
    sha256 "254b2260c87f83859b8f50469fa0ae657fbb310985382c2f0db708901620648f" => :sierra
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
