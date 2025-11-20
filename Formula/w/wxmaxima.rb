class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  stable do
    url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-25.04.0.tar.gz"
    sha256 "ec0b3005c3663f1bb86b0cc5028c2ba121e1563e3d5b671afcb9774895f4191b"

    # Backport fix for wxWidgets 3.3
    patch do
      url "https://github.com/wxMaxima-developers/wxmaxima/commit/0449b7e42809db16df87c3fbe95c37a756c04587.patch?full_index=1"
      sha256 "9784a43c08ec0b57c6ba710943a0665bbcdfc16bd4ab59fb4dc7c26586291c34"
    end
  end

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "cc11b4097517d7f5703e8f68fce4584e1e0bc54608d734c8d1d0375635dad68c"
    sha256 arm64_sequoia: "ec8ca3fae6f7edc7593eb84c6c4216f9ae2dd4a3c014dbb7553acd78e3302e3d"
    sha256 arm64_sonoma:  "7d82d9ec873119248214f833fb7029eac8875aa57c5701a57370b44f76e3cd58"
    sha256 arm64_ventura: "d557599c3b3eefd79b147758ca60611e9b6d57e57c1e41c004140e418d2205d4"
    sha256 sonoma:        "24fa662cd77d0dd9f745942e8c1b74467b3711e03f13b9dae6f087687abaec69"
    sha256 ventura:       "b66e7b2778a0b7588bebac86db1f4b3aaa7726b40f5acb606fc36a5e096b2ffe"
    sha256 arm64_linux:   "4bb515d654a2f26fc2b3ca0f8482970c48d475ab3329e262504ca6a24e2a51d0"
    sha256 x86_64_linux:  "e321b5e9522666e570bcdbec80ab1573bdc874933adbdcc4ce324393dae553ee"
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

    assert_equal "wxMaxima #{version}", shell_output("#{bin}/wxmaxima --version 2>&1").chomp
    assert_match "extra Maxima arguments", shell_output("#{bin}/wxmaxima --help 2>&1", 1)
  end
end
