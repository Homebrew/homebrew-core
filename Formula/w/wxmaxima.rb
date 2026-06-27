class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.06.2.tar.gz"
  sha256 "598c202321bb652785b6e889cb4222f00b0688d5412fa318dce70acd3a5e2666"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "1fc6999d3b8808141273babe7c611f8d78df849f573b929f01cf0b75184be63e"
    sha256 arm64_sequoia: "038bd40d21bc7414eeb5750ee64a2f5015c2a35dbdd6bbb0e52210b80dd2d8de"
    sha256 arm64_sonoma:  "87f5640e1481f2ccdfe8502b24979a1c7008256a6c8a3110bacf3d2a76f93dce"
    sha256 sonoma:        "eb1b4652199f4f1b99f83727da1f9c65af2308fdd7a39ba13bf0420db6b04c43"
    sha256 arm64_linux:   "4571277628ab6609cab620c7a26addd65b7ebbf8c785885e05b036e857ca650c"
    sha256 x86_64_linux:  "72563892ab9b3f0b6c823845894fdc710a093f60f975347102461cfcd6ce7fee"
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

    # We don't build wxWidgets with wxWebRequest; guard the upstream caller.
    inreplace "src/wxMaxima.cpp", "#if wxCHECK_VERSION(3, 1, 5)", "\\0 && wxUSE_WEBREQUEST"

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
