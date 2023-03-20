class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-23.03.0.tar.gz"
  sha256 "eedaa082353ad2526099982e4e6b4497355ed558464ece576876d6e6941e5e6e"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "8768e12f524ecb1329a4289bcca17b682f9905289eae92f346945597068da542"
    sha256 arm64_monterey: "8ddfa98b34f7fb7a7a16ff099b79f9d7dbeeecfce5798b2306c47fc2669474f9"
    sha256 arm64_big_sur:  "20e1d033e91bf84aa4d44fb53fe31d36ce626f4ce5d05616d62eb37fc898ecec"
    sha256 ventura:        "1266cb56c7309c3a1c9573237c1d0baa0467ea853591cd936efa02fc14abb9ba"
    sha256 monterey:       "4fdf6f30f72f38bc5536b7bb4b5a47f59a418905e6c1e4e4e5ed1175781f1bd0"
    sha256 big_sur:        "d08b7f0e10d6082066a165c162563ee25948fdf3d0676fd3632b7b66bb06dda6"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxwidgets"

  def install
    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    prefix.install "build-wxm/src/wxMaxima.app"
    bin.write_exec_script prefix/"wxMaxima.app/Contents/MacOS/wxmaxima"
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
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
