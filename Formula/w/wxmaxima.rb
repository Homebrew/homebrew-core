class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-25.01.0.tar.gz"
  sha256 "18cce36cc6c41ca012ec128aafe3c96659b1d670f8a8f7d98395eac1a19ade6f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:  "2b8ee335d9432282f9a96e4f17b5827621a869d0fc0f61a209fac4a19642d397"
    sha256 arm64_ventura: "1f1af869814afcf0e1b2aa4c2a1508cae3aeeb945248993f3f37a562e6689e5b"
    sha256 sonoma:        "669e8564ed22b45469abcfd49b7eb3bc9d66942c69e5e56fda42b582f6138f3d"
    sha256 ventura:       "2e6e2e79a4280ea8e2183798300630bf8fc78c006cd8598c6c8b97a68a2d0dbc"
    sha256 x86_64_linux:  "6c926aaa5d88ae8a4f098ec79185b5daa8b75c0a6f623b79af2a85a8b0ff237d"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build

  depends_on "maxima"
  depends_on "wxwidgets"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
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
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1300)

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
    # Error: Unable to initialize GTK+, is DISPLAY set properly
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "wxMaxima #{version}", shell_output(bin/"wxmaxima --version 2>&1").chomp
    assert_match "extra Maxima arguments", shell_output("#{bin}/wxmaxima --help 2>&1", 1)
  end
end
