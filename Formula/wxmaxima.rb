class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.05.0.tar.gz"
  sha256 "a0140b9f6171540556bd40c6b5617eb9ea224debe592014cbfabd0c095594b93"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "a51d1ccf532d56b1bf6d078d7192eb1de175905b7aada0c3b8952961036167b8"
    sha256 arm64_big_sur:  "5c3482950973cb51d01ca0753d7673469cf820d7aee2250fbb79fdee522b0ddc"
    sha256 monterey:       "c30018e1a23d688c2d121ecbb84ab0fe3a1c54b6504f6d049d557f478522d138"
    sha256 big_sur:        "e654e0a7487eb02fdb2dc5e492146c30c3e06122d9044898fadcd6e540a84ae0"
    sha256 catalina:       "b47d0975e48f7675ad05e85685a9c372c12eb32b8d7c956c28ce770a552dd270"
    sha256 x86_64_linux:   "ab153232833dc68d83b9e3753d79edcb898e88731a878e2a43068f745000befc"
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
