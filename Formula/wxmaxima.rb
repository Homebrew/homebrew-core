class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-23.03.0.tar.gz"
  sha256 "eedaa082353ad2526099982e4e6b4497355ed558464ece576876d6e6941e5e6e"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "54ef2afe6ed2a7a28bf5e10e2c6c6d5609b8d3fd714a001e816d98bd7caed3e0"
    sha256 arm64_monterey: "d0d56a9722075df7cff4b11487411ba40edeccabc928c09fc03d8f82ec417c7f"
    sha256 arm64_big_sur:  "adda927bc60a5bcedee9fefa88e92c6868f67a8b79417a3763b361c8c1be1dff"
    sha256 ventura:        "a8f6843fb4f36297c6386c78c80ba9fe2a120bf0bc3c465c4ed20e4557814c67"
    sha256 monterey:       "8b43dfade839bbb553cdc0a69928813759e856cee86cc54c48530240c6e4aaad"
    sha256 big_sur:        "6660da135f46a5a9ad5e52f1c2a74f0ecd91a8a44468e34dce7d79923f28da11"
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
