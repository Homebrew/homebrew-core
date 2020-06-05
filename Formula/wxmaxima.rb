class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.06.3.tar.gz"
  sha256 "8de5a16b7147569f02426db9fe3f6ebc2424333f90e22e5ae6674fdf4f12a5b5"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "58e8a15e6e2d0cd6773d8a2e3babcab6be48f1e98681ee75d9b6c12d9da48353" => :catalina
    sha256 "d4c892231b3319a2bf825a0ee23bcaf40d7ec4b1bf44a0511b14522e7ffd531c" => :mojave
    sha256 "274a4fd53610dee5181fe984586518f0c86ade05e6b327092a506207cc45dcad" => :high_sierra
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
