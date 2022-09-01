class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.09.0.tar.gz"
  sha256 "dbe6b1cba9a14116c4d79b0811f042b318b362eb2cc5b41533967693c0caae95"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "866b15ce6884bc656badc44741332fb6384a41ae2a10647aa314515bd310728a"
    sha256 arm64_big_sur:  "e0000e0eaea67d73e42cf9189c9a9cf138b32c281f9431f90de442512da48040"
    sha256 monterey:       "2e9c6669e599f27521441335baf9c2f0080b6c046e6bb25b04938175ef600f8d"
    sha256 big_sur:        "7853c4c1e1edb1781cfe06f62b4bfb99e2b75c19452393594c7834ed97046fba"
    sha256 catalina:       "c4849f6ed0a27363d6b3d3ecb8303887ad8d8e2e7841483cbae8bee3ecae2d4b"
    sha256 x86_64_linux:   "46115cdf5170522d9ec330253e6ad97c98b10dc75c0b4b3b8fb4978a6c155090"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxwidgets"

  def install
    mkdir "build-wxm" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"

      prefix.install "src/wxMaxima.app" if OS.mac?
    end

    bash_completion.install "data/wxmaxima"

    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima" if OS.mac?
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
