class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.07.1.tar.gz"
  sha256 "8e62305de624456330a1187438cef11113fd6c02647307eeb33c2b9d15ab7b3f"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e94e9301a88518ea723c446b307e86ad850cfc929bddfb1ce59c911429d7111d"
    sha256 arm64_sequoia: "aa6303072e414347c01ae8b9b6df2744480f5aef44309fba41f24a5e77d332e7"
    sha256 arm64_sonoma:  "fc18ec00f02167411fa0c17410baeaab8f525d0eb972e60f075666e0e6a272c7"
    sha256 sonoma:        "6580590fa27dc65d4a35599f5b36b772ac22c336c06996397611de66b8db92fb"
    sha256 arm64_linux:   "83b7a52e1f4f46634a52d7a4bd2cdad47bafa00b820eedc07717a4392818a56c"
    sha256 x86_64_linux:  "08ddd24f64644a8625fe56492ee5355491fe85ba741751919442a93b24628fb6"
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
