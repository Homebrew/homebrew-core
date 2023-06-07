class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.14.0/source/quick-lint-js-2.14.0.tar.gz"
  sha256 "b7420dc6a09a4d713f666f1cebf0285c25ffd67da1e167a4dcfa8572ffde2bfa"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "acd5f748bfd5c2866fdec857fb8605f5ddbcbaa2cc35cfc174991769ad7bb8ea"
    sha256 cellar: :any,                 arm64_monterey: "f046f1a8c33e9ff5035608210a942a4bb72158a2e308a23640fdcaaf9e4ee798"
    sha256 cellar: :any,                 arm64_big_sur:  "d811d91da373825de1cfa1de0045d7f411c9858e20fa6899c2707ba414306777"
    sha256 cellar: :any,                 ventura:        "e5ca9d6cd4daabfc51217f07e6b374765168d3a31a9d0e1f50b26c09659514b2"
    sha256 cellar: :any,                 monterey:       "fa22a179acf073bb38355ca6b20b608658175769ea90b038a2c8e83b2976a963"
    sha256 cellar: :any,                 big_sur:        "63aac6f37f6d7ce114634644f21cbe4b1b49790c5067d19cef00a4b959471e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac28e0f9418b6481a0543f49c0cb660bb2b006dc889ac92b142c74acfa611ad"
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
