class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.03.0.tar.gz"
  sha256 "2192f804588511e9a796ad0b677e6f4721bb2cf2a52766f3d47f4528ad0ce0a4"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "718f9ae3af0763c8094b715d0e34857858bd5f3c6305d1b8ac39cb1b8cdb4e4e"
    sha256 arm64_big_sur:  "2678b66d83d8bd57c907adcca4a7f936b03faa8b0770c10f93d83e35c1ac2e7e"
    sha256 monterey:       "d71b3f3ccf429325724186d915909ee47ba9a1ac6a44a1666a530a1857328fa6"
    sha256 big_sur:        "9596ecb5db2ecd423aa650a3cc38d9d2daea37e5fa84f0cac09858d8c935f1c0"
    sha256 catalina:       "1b7a63db2fb176a15c2eabd00e0081c5cd22920ef0c5c1f720e98ec09287bf4f"
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
