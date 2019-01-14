class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-19.01.0.tar.gz"
  sha256 "f28dfc9a717e4a91446cddba0e010c4383a3e973a11889948bd65ea311df28fc"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "cdf9cc0a4b71f763fdacf3cddafc52e70258cc855c86dad4144f0bf2523b027d" => :mojave
    sha256 "1d1809d0f19180e1c7f1eb55c54a0b09c859589a20fd72591f2437d0a1802437" => :high_sierra
    sha256 "3cdeacd53880490bce5f9d7c4498c1fdf778ddef7d21f4fa3905c317202b6985" => :sierra
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
