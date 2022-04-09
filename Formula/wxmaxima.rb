class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.04.0.tar.gz"
  sha256 "48744a3f29fa9abf20788bc0b136c283cbbb0397c74ec79b41e5e6d856d7d65a"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "899c19dff48cb7b2e51dad96b23cbb6050b77fc1720e5f6af8156deadac39ef8"
    sha256 arm64_big_sur:  "2b7a0559054530909952386b14b27d6f099eacf2c2e9135bfb03b97b55ec1028"
    sha256 monterey:       "d0d34441e246360d02e3c86d654a3b1e6bc11b2988d4465a465b0677299bd9a4"
    sha256 big_sur:        "6f99223fac1729a95956c6b418be0b6dfb3a4385a00079f82b5059d5434e8138"
    sha256 catalina:       "f25383a3f0d54812d03c0299638070ea1f746d298250d14fb29e3514b24b7345"
    sha256 x86_64_linux:   "7bc367624a42b0062c316737f8cfd7e196d934d0c0cc7160d127735284e0da5c"
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
