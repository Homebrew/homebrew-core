class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.06.3.tar.gz"
  sha256 "8de5a16b7147569f02426db9fe3f6ebc2424333f90e22e5ae6674fdf4f12a5b5"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "965b35fa40b63c6cba031dc52d757215b46ab75589cb32790a96804516d6836a" => :catalina
    sha256 "073ce60b174bd45ac555c69326214aae77b670df2d515f8a8a3a5f27d7b3176c" => :mojave
    sha256 "d2cafd9ee6bd02253283cc80e13497cbd889c2f87a8f9c5ea9a895bb3ebcee73" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "maxima"
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
