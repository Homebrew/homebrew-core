class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.07.0.tar.gz"
  sha256 "0ab31006eb00e978ba8ecc840097272b401c294c0dbf69919ec8d6c02558e6f0"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "9e9bdb5eacc61fdad7945970db68f8d04bdf96172643301c918ad2cb028dfede" => :catalina
    sha256 "db544d8b5bb33915a44bf93382c182d56935e2a88fab17ff4d631095630c9e0f" => :mojave
    sha256 "0942521551716a682c363ad83f9bc0ce90cf53dd74864d31a1dfd7eab8dd680e" => :high_sierra
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
