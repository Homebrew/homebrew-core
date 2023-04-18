class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-23.04.0.tar.gz"
  sha256 "54388c4314625de2ede4da61a505b71158ddbd7019fded35398b5b80e1e3deaf"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "1f9ba831e39e2d13806002008e2d8d0a60cdf965ba7ef120ecd8779ef896fc95"
    sha256 arm64_monterey: "dc7aee1df4631401e68c2c126703aac77f2abf551f57a978e80860966bab9474"
    sha256 arm64_big_sur:  "20c7e38c121db31240c49df646b3b8dd9898b3e3773e7cb96b1f281f1087fe0a"
    sha256 ventura:        "5cd72f510559f1a20b547b381bfb4b5e782b71cc9f4d63fa93469d7d4b242002"
    sha256 monterey:       "174f207634004a717baa1684d2a2b595a2246365d569034b09180ab80c179999"
    sha256 big_sur:        "a042be860717d41146932d42d418d2bcb7a71c751183bb8614a68bc6fbb07606"
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
