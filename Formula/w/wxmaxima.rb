class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.05.0.tar.gz"
  sha256 "1380c58d27e1b2e0eaee543936ca188658a829fc397cb9e064e8803209e3475f"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "487a4a3970f894abc5c7e2766375db3445313473d993a1d7929e9d20ae97fe9f"
    sha256 arm64_sequoia: "2cb16cb63d785c755eb2b3571c408ea7bcefd4f4cc70684c64434469e7f7542c"
    sha256 arm64_sonoma:  "1b95a2d51fab176ed2b7532c3bee3b790680e11b7c5f1438efe8e43df03b67f1"
    sha256 sonoma:        "885684a65b93ee503798102ff582d5bef1709612aa7ab7102e8e3c367422aa3c"
    sha256 arm64_linux:   "8779e84a95c34255c426ab52bc4092a92d519ea2dd2f7c7886f32c3e653ded7b"
    sha256 x86_64_linux:  "7f2fb57364a90a49a59860f5dd6f08765a66e07ab131d641f6aafa0451e107a6"
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
