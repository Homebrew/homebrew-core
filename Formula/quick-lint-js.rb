class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.6.0/source/quick-lint-js-2.6.0.tar.gz"
  sha256 "6fd402e1d0743adb9e862532e25b2be09f637d4c45cb964251ac0f52a1eb5d5c"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "936a528fb6e0838db469e371a67e247b609f2195257f815963895785d26fa4bb"
    sha256 cellar: :any,                 arm64_big_sur:  "ae523e10ecbbb02553274c384a14d571976e530236310316e1fb47e5afe135ce"
    sha256 cellar: :any,                 monterey:       "91948d324c366fceba43db6c1e87af28a58c01719e3e6a50d32c0e607437c729"
    sha256 cellar: :any,                 big_sur:        "6c4591b9f3c7dc52f61a4f867ab859a6e5e2520b85077788cd26cbb8e902a57f"
    sha256 cellar: :any,                 catalina:       "26104beff6a3db305f6017f337fa3d3b30025a32ce11290083ff8dbeeb81342d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f394a9ddd5de00a374d1a8b31678201adf32afdba9289c9b806b8f6755056d"
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

  # Fix build with simdjson 2.2.0.
  # https://github.com/quick-lint/quick-lint-js/pull/779
  patch do
    url "https://github.com/quick-lint/quick-lint-js/commit/a82c706ef4b8d1e7aa71b6ff0d244670a50d69ee.patch?full_index=1"
    sha256 "445b11501ab08613a90f0107df965b9e7b420ad2e0139a47deb0453ced5b86f8"
  end

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
