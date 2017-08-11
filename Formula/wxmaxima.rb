class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://github.com/andrejv/wxmaxima/archive/Version-17.05.1.tar.gz"
  sha256 "72394f266a784e433e232e600e7178fdd6362fd33f8ac11703db10c780676037"
  revision 1
  head "https://github.com/andrejv/wxmaxima.git"

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

  def caveats; <<-EOS.undent
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    assert_equal "wxMaxima #{version}",
                 shell_output("#{bin}/wxMaxima -v", 255).chomp
  end
end
