class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.01.0.tar.gz"
  sha256 "1716c4f27636f909673f63ed0c7c30621683e35eb7bf05a5d5010fa67f0397f6"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f6877ee5d4e4da0c2b6f315e2c27183b6019c5f565edf66dba54139df3eba76c"
    sha256 arm64_sequoia: "877faaf122aed878380534e047e5d346fd582f8574e5c131f4a9e58f597c4a3c"
    sha256 arm64_sonoma:  "63e7af14fc0ced6e4b9d359bb06706e4e4e8e151958b66246c812b0257f62822"
    sha256 sonoma:        "a19bbfe267972e72605bb7884c0c9d8b9fb539f937fd642a87865e3c1d67cbbb"
    sha256 arm64_linux:   "43c9ad33a0979f718b17bea6b4960ec3a7a79d2317df34274f4f25ed032f3301"
    sha256 x86_64_linux:  "62036c3bcfda784e60870f80e48e8f150baf74077c7d669d6da629eb470f77ef"
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
