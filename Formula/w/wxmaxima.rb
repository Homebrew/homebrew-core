class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-26.10.0.tar.gz"
  sha256 "6098d3b54b531ed59cd2aff568f70039b41f6e7f89cbb84d1da2e5b796a7bb71"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2abd7a2e0ed1660cd92a2ad44b9aff1b7613fd6dbceeb41345a58e9022286cf8"
    sha256 arm64_tahoe:       "c45d6e4433850ed3378da18d8ebabc0db4c87fadd7d861afdb85224da2b6abe8"
    sha256 arm64_sequoia:     "39161c42d8015ad2bacf4fb342c37a0308b5c2222c67477f63b4090ae7713d83"
    sha256 arm64_linux:       "fca82ecdcc2f4100e4a74395d65955a9033bc98a84c4626af480cc48b49674b5"
    sha256 x86_64_linux:      "e90de197e91139da291c8654230caa1d0e1c94c27696f8a776670b2cbe046c1d"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build

  depends_on "fribidi"
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
    # Cannot run any useful test within macOS sandbox
    wxmaxima = bin/"wxmaxima"
    assert_path_exists wxmaxima
    return if OS.mac?

    IO.pipe do |read_io, write_io|
      pid = spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"
      assert_match "wxMaxima #{version}", shell_output("#{wxmaxima} --version 2>&1").chomp
      assert_match "extra Maxima arguments", shell_output("#{wxmaxima} --help 2>&1", 1)
    ensure
      if pid
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
