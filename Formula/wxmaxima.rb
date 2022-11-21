class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.09.0.tar.gz"
  sha256 "dbe6b1cba9a14116c4d79b0811f042b318b362eb2cc5b41533967693c0caae95"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "899e8912c23d9a14d9f0fdfa6ad003ac937b3ae18bdc9236d524595b137349d3"
    sha256 arm64_monterey: "a1eb891bb6f63d15a813fce71315c29ccfe56cb546d80cfc5fa98dd0de38ba8d"
    sha256 arm64_big_sur:  "22b98a12ef976355a944adc40e337cb6127ca3b257519f557f102af90740764a"
    sha256 ventura:        "9724cad06a935782af9e2b3a58a39e3ed37af3a973ae3582b55b030f148815d4"
    sha256 monterey:       "7dd8cefc54f437aea6e464c8590808373acf89ea93d80cb3e048884c1984bbc2"
    sha256 big_sur:        "1f2db3fd26b64e5f47f2bf2e2f91b40d3ee04c9005635b96c8f2814b20d318f7"
    sha256 catalina:       "316b59a8ba83bb00f7e8f83a2bc780893861185428f59900be348be2ead5984a"
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
