class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.07.0.tar.gz"
  sha256 "0ab31006eb00e978ba8ecc840097272b401c294c0dbf69919ec8d6c02558e6f0"
  license "GPL-2.0"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "a313284d285cb130b1567536d4004d96e29da2a364f69f066360870bab89574e" => :catalina
    sha256 "1f7c0913f429666b64caa646f4e425c41fa451d2f7d859ec72fe89961c2081e5" => :mojave
    sha256 "cd4d134f65f80c72bf5191612b6555ea540b0a4b697cd20c5e36d605470db731" => :high_sierra
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
