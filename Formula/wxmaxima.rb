class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.04.0.tar.gz"
  sha256 "bb4310b0bbbc4023c1921deaa4b43e364e31dbece7e3ca93590ee569b5dba392"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 arm64_big_sur: "5e4d5e20d4b499e1fd886af526f4bb49d51576472786a3ba8c07ec592235de73"
    sha256 big_sur:       "710df86666c8080eff66d71a0636ddc74671dffc88041b3d6c9395ef1f50ee66"
    sha256 catalina:      "39f6497ab8fa8f2a4d70cf94c2012feda48e5ceccb58bf4a4bad5676d97584f4"
    sha256 mojave:        "4bab869d3cb60549c38ed79f2505988ff437dcc85b35f461ab35b7d853dc99eb"
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
