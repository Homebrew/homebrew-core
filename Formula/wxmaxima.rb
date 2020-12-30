class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.12.2.tar.gz"
  sha256 "7d2ecf6a19e3ba0f6d3889c1855a85884b71365f5844003c7f3c996e2967d65e"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "e313165add19cf7f2453302d6d98453a48f4a4f249e80d5149f3c6b5559b69e4" => :big_sur
    sha256 "2ef1d767ca05d9bfdd8505c16c6fddc85512a0c9ab2f0fdfdacc5f631745d9f0" => :catalina
    sha256 "aab84e7e3ac951b2a9fecf735cc6120f5c62b457d77e842c530907fad1862c9e" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxmac"

  def install
    mkdir "build-wxm" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
      prefix.install "src/wxMaxima.app"
    end

    bash_completion.install "data/wxmaxima"
    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima"
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
