class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-22.04.0.tar.gz"
  sha256 "48744a3f29fa9abf20788bc0b136c283cbbb0397c74ec79b41e5e6d856d7d65a"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "624a0e04af2f0cafa896771cde72a9c8c6a0eed2b9a03f997d02838fbb6587a1"
    sha256 arm64_big_sur:  "812352b0fd5d6f1b5b621f323c6cd51598456f8155ad43e88e590c0a79727c72"
    sha256 monterey:       "d5d4809972b045e3207a4695ed8eef649a1c18847d37d12a4c047bbc37fd9a1b"
    sha256 big_sur:        "a37703d377852b8488f04d8fbf4aeb902f9a4ba6de57fa42bbc2a5eb0f851f84"
    sha256 catalina:       "1d9e48565e6d961d4305514a9364a074c1f1fe21c2a56c72cb7b97ff81b19309"
    sha256 x86_64_linux:   "5d8b4e941ea398c23d10b93f1f4720820a5d58f909d12f8408fe30a76c1531b4"
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
