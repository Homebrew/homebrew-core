class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.05.2.tar.gz"
  sha256 "4d2d486a24090ace2f64ceccb026210e2e6299a32cb348d43134ef80440bcf01"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "c5885649ca8ab371701954eb6315e59e97136dbf852298cfceb78c5d1d0f56cf"
    sha256 big_sur:       "a02efeeb839aa82eba7f78634e4c2cdca4d4fbb44106a572d4358cc6d6120894"
    sha256 catalina:      "1ba9b4c32bd55e704584a4d1b31abf823fd8e6cfe794a9b329ec40fe6ca1457b"
    sha256 mojave:        "63862e6e1cdda9db206fa8f1eb1280642be7e8d35b53b8595c5013d6c83369e8"
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
    on_linux do
      # Error: Unable to initialize GTK+, is DISPLAY set properly
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
