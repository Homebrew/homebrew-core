class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/refs/tags/Version-24.08.0.tar.gz"
  sha256 "a0957c1852ca2d93e34f8f0329673f40af065e7648739d088da28bd33627b758"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f5f1e8d4ae104152f9f85bef2f9552647465984eaad5d38ac275103d745e9c19"
    sha256 arm64_ventura:  "3abef2ef7771cbef1c2b3a9d2e9f5d2662a5d4c0b625c31f644086f30f73831f"
    sha256 arm64_monterey: "e1e390f4dfc27d2bbf760aaae35ec14abff1d185cfd4ccef045c1a30ce88ce6b"
    sha256 sonoma:         "47ad334e5899b328702ab71f991cdfe16bcac85b370014a2035dcada7ad7f97c"
    sha256 ventura:        "bad0204f986887c72b03cbd7750cf96a11447f5d350b40fe24f6d086e1ba20e2"
    sha256 monterey:       "0384aa9700ae2c7c698865f3c2982aade375a141d7d1ca9ead03bb4a9fc04739"
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

  # fix version output, upstream patch ref, https://github.com/wxMaxima-developers/wxmaxima/pull/1937
  patch do
    url "https://github.com/wxMaxima-developers/wxmaxima/commit/077ec646a11bfb5aa83a478e636a715a38a9b68b.patch?full_index=1"
    sha256 "15fb4db52cb7e1237ee5d0934653db06809d172e2bf54709435ec24d1f7ab7a9"
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
