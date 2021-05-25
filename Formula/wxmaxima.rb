class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.05.2.tar.gz"
  sha256 "4d2d486a24090ace2f64ceccb026210e2e6299a32cb348d43134ef80440bcf01"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "68314ebcebe36aaa5eacdac464c9e0be072845025badf0415645c5a7bcb84ad6"
    sha256 big_sur:       "1aa82c15d4dc6b1c9cf3d37f4a0b0e634ae9274a40f95d0cc580a624b47f15fe"
    sha256 catalina:      "375c13df1255b033e94e1d15203cc2977556e3813679223b7298a4fc073ff66f"
    sha256 mojave:        "5dd54bf314d07250c5f621994334158e88493c2b508f45371e71ca4114d4dc4c"
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
