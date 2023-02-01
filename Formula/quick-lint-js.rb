class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.11.0/source/quick-lint-js-2.11.0.tar.gz"
  sha256 "6d3d580783b219d8ff4f7883f149a1f9b47dba0fa4a40e172a7215c918f67a49"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "721baf914825e4bf1b3c0a4246e6779f14b3494501931aa66f0346d7aa212152"
    sha256 cellar: :any,                 arm64_monterey: "61cb156d2d3a82924916311c6e98f11dde02c5fb078aecdd2ce1bb10bcc4e607"
    sha256 cellar: :any,                 arm64_big_sur:  "7d98c936c95defcb484c6826fedca4325afcf2b8e77b4ddac5b839f3edd79a3b"
    sha256 cellar: :any,                 ventura:        "07d193c71fb4f6fc0a924c1b4fcd9007c38c7f8e737632cddd7c4cafc393963d"
    sha256 cellar: :any,                 monterey:       "e93f4799baec046d4c117a8194bc708e49f7b1ad605099191b0e450834cbfc7b"
    sha256 cellar: :any,                 big_sur:        "7ec82f1bfb7898f689c2e564bece5f276d29e47c06f2532026140e2613c545a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f67d21d5b12e49dc01dfdb01a1a1062c77a10d0aa8d15a71667377051e110b7a"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  fails_with :gcc do
    version "7"
    cause "requires C++17"
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
    system "ctest", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "build"
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
