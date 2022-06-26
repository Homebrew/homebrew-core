class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.6.0/source/quick-lint-js-2.6.0.tar.gz"
  sha256 "6fd402e1d0743adb9e862532e25b2be09f637d4c45cb964251ac0f52a1eb5d5c"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "93cca33bc1016370af2b9943891dd9c176fb909aec794785adfe8d726185960b"
    sha256 cellar: :any,                 arm64_big_sur:  "8d6bd018a8426e914c91993093530f8a71e4f544c4eeea6307afc633aa5a9b76"
    sha256 cellar: :any,                 monterey:       "79af5cb7264a2e65f361daaf9e4afb0e7be2492c0b72eb3f765ea78d9bd93317"
    sha256 cellar: :any,                 big_sur:        "00d8fd8601c531c16f774878de30ef9933bd4eca4b553383abd0ccace620d072"
    sha256 cellar: :any,                 catalina:       "853bb75f28dac35a8692526377c81955321ff25cbeafcce356a797cb6864e3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a109a1ab964655f3454994f56efd6f823295b11bf56a94dbdbddb8e65a63b9"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  on_linux do
    # Use Homebrew's C++ compiler in case the host's C++
    # compiler is too old.
    depends_on "gcc"
  end

  # quick-lint-js requires some C++17 features, thus
  # requires GCC 8 or newer.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TESTING=ON",
                    "-DQUICK_LINT_JS_ENABLE_BENCHMARKS=OFF",
                    "-DQUICK_LINT_JS_INSTALL_EMACS_DIR=#{elisp}",
                    "-DQUICK_LINT_JS_INSTALL_VIM_NEOVIM_TAGS=ON",
                    "-DQUICK_LINT_JS_USE_BUNDLED_BOOST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_BENCHMARK=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_GOOGLE_TEST=OFF",
                    "-DQUICK_LINT_JS_USE_BUNDLED_SIMDJSON=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    chdir "build" do
      system "ctest", "-V"
    end
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"errors.js").write <<~EOF
      const x = 3;
      const x = 4;
    EOF
    ohai "#{bin}/quick-lint-js errors.js"
    output = `#{bin}/quick-lint-js errors.js 2>&1`
    puts output
    refute_equal $CHILD_STATUS.exitstatus, 0
    assert_match "E0034", output

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
