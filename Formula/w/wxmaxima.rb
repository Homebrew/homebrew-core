class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-24.05.0.tar.gz"
  sha256 "21dc8715b71372dc35743486307254a5a0285f35a6acbc68b894d432c4f14c98"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ec022b089287e461e12f5f49601a2fa261a5082ae2ab8d27dfd39c920c8a63bf"
    sha256 arm64_ventura:  "a62433474bbe7929439116f5153a9863e65b8b5d3537de8fb8493c5595412753"
    sha256 arm64_monterey: "c7c49e7d663adc19885e070e4c548dfe45b52c6117eff9d2492e0fb630914e90"
    sha256 sonoma:         "f726e02b227c56529d36bf5ea0a0624d389d1b2d9968ff158e359b7686f8bdae"
    sha256 ventura:        "ecaad820ffc769fb4d1277e1834d70bbc4e4c14934e1cc1d5f530b6a782f38e3"
    sha256 monterey:       "78b9a77bc9ede9dc2860455a6711204eb761b444e02ec66524c6851d9a3bfc2d"
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

    system "cmake", "-S", ".", "-B", "build-wxm", "-G", "Ninja", *std_cmake_args
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
