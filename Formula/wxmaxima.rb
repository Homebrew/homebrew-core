class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.05.2.tar.gz"
  sha256 "4d2d486a24090ace2f64ceccb026210e2e6299a32cb348d43134ef80440bcf01"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 arm64_big_sur: "8e190c393d93dd5cf7fac3876b71d2c34ecea023302e04f0ff41559f6811cec8"
    sha256 big_sur:       "cfbe8ccaf647ffbfd9b7ba08a8b010a7aacc9fd9ffacefef9056b0617c48b940"
    sha256 catalina:      "6c32e30891d4b64e8c447e5dc833ee9972f6a3cddc088fee122ec6f8094b1960"
    sha256 mojave:        "d468c07f5e21def0f0a5fe29d1c7906ef577eaf3c9c5109e9cdc32a2347ba975"
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
