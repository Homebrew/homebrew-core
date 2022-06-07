class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.05.0.tar.gz"
  sha256 "a0140b9f6171540556bd40c6b5617eb9ea224debe592014cbfabd0c095594b93"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "778a293f94761b9bfd05ff83b1560b6995cecd2b3aba90eaefc8859e76f2a310"
    sha256 arm64_big_sur:  "ea2d3a5c1966fa12f8f100086234b1a3b2fa1bd862a728d4ed2c63cde975033d"
    sha256 monterey:       "0d26505bd559f98e95df34be56bfe9d05bd794bd4d28d64268b92cb34056feae"
    sha256 big_sur:        "7e00267d843814c571690d8357cb59e6c05b14c2a0dd8095893bcab1b8d87524"
    sha256 catalina:       "81849af465fc704e934ccd5bd47f2f7db36985c503047ce42b9b4adea632b985"
    sha256 x86_64_linux:   "e2658a29828d6b86fcbe3722251f06034b3a1b7ef3a786a1529ea01ccaa8ece4"
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
