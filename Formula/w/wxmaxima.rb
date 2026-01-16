class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.01.0.tar.gz"
  sha256 "1716c4f27636f909673f63ed0c7c30621683e35eb7bf05a5d5010fa67f0397f6"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9e270b833c8403d08a0aa85b14e9b0cf1e0827325a1dc12270f9badaf7ad8e61"
    sha256 arm64_sequoia: "53bc46eeadfd5673a607207fb7168e1917668aa4a1df24567f4bf299095940fc"
    sha256 arm64_sonoma:  "c1c38751311436cb37bfd701862e83a5efc75918cf8ed23c466d94965776747d"
    sha256 sonoma:        "7f8d1081ad2c1e05c5a2e9ad0ca552f5d8ea9cea965fe220cadb0eeb1c450609"
    sha256 arm64_linux:   "6eee61bbe356b373f5d8f5ceb80f2b76b8f3e38885fe9acba4da2ec50e6393e1"
    sha256 x86_64_linux:  "53f774facb87ebf51f2b9a93c8b878494ee97fc297c58275b10686d6e4851867"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build

  depends_on "maxima"
  depends_on "wxwidgets"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  fails_with :clang do
    build 1300
    cause <<~EOS
      .../src/MathParser.cpp:1239:10: error: no viable conversion from returned value
      of type 'CellListBuilder<>' to function return type 'std::unique_ptr<Cell>'
        return tree;
               ^~~~
    EOS
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs
    inreplace "src/CMakeLists.txt", "fixup_bundle(", "# \\0"

    # https://github.com/wxMaxima-developers/wxmaxima/blob/main/Compiling.md#wxwidgets-isnt-found
    args = OS.mac? ? [] : ["-DWXM_DISABLE_WEBVIEW=ON"]

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build-wxm"
    system "cmake", "--install", "build-wxm"
    bash_completion.install "data/wxmaxima"

    return unless OS.mac?

    bin.write_exec_script prefix/"wxmaxima.app/Contents/MacOS/wxmaxima"
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
    wxmaxima = "#{bin}/wxmaxima"
    wxmaxima = "#{Formula["xorg-server"].bin}/xvfb-run #{wxmaxima}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match "wxMaxima #{version}", shell_output("#{wxmaxima} --version 2>&1").chomp
    assert_match "extra Maxima arguments", shell_output("#{wxmaxima} --help 2>&1", 1)
  end
end
