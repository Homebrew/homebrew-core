class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.05.2.tar.gz"
  sha256 "4d2d486a24090ace2f64ceccb026210e2e6299a32cb348d43134ef80440bcf01"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "78916b4586ee997df546d122218d3a43e9038db4edffdb53289a97c5ff39632d"
    sha256 big_sur:       "2b8f8beb1f2daa77e0750a660bf90fcbe60ac113947dc6e09a70e26af20faf58"
    sha256 catalina:      "4bc58244e091d68df832006318abc156ce528acba0e7eeb157ba42504fb913da"
    sha256 mojave:        "8b9b6be8aabfbe43db4124dc916c91d799cb384ea8c83828a413b95e8da27741"
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

      on_macos do
        prefix.install "src/wxMaxima.app"
      end
    end

    bash_completion.install "data/wxmaxima"

    on_macos do
      bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima"
    end
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
    on_linux do
      # Error: Unable to initialize GTK+, is DISPLAY set properly
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
