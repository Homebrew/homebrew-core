class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-17.10.0.tar.gz"
  sha256 "97ce3e0a9f8d38a11e9170fedc8320eece5d0a57a8c8cbef7bc8856dbcbd9770"
  head "https://github.com/andrejv/wxmaxima.git"

  bottle do
    cellar :any
    sha256 "05282c6782b96398eb023255801c8f10c5983d61d9339ccde823f0052af51ba0" => :high_sierra
    sha256 "9555a0e4f5680489639e1c7c8602b7170ef14dedf9213679c911795a8871249c" => :sierra
    sha256 "139a99757866736469e8c90bbce49ccf93dfa1f351b2650d779ae3f3bc09ba1b" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    cd "locales" do
      system "make", "allmo"
    end
    system "make", "wxMaxima.app"
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
