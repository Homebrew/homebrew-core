class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.9.0/source/quick-lint-js-2.9.0.tar.gz"
  sha256 "b0010e2025c3250106df9c2cd2aa67f4643c037159c2f05ba97cbc9b02b04837"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d26a4d2030ee6e095f9b4d5391f03b18ca5de07bc57f42aa98e3cb6c225d0a1"
    sha256 cellar: :any,                 arm64_big_sur:  "ef8d654ce348149b696582f64b157c25c3612248301884700f9de3b3c536595d"
    sha256 cellar: :any,                 monterey:       "fa9c5ef8df43599ae33545847712efe1164cf743cb154341e0debcbafdc5dc6c"
    sha256 cellar: :any,                 big_sur:        "45ee48e08aa66b06750c8d71454205734e5093565c3b882f2b69d4cb4865da13"
    sha256 cellar: :any,                 catalina:       "430c07ff60e6c79610e33c4a0f89dc0de5a630b739a31ba77154eb487acbf2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c862b6396352a43916a376a0d09d9476273903f9af3ce2e2b3a24b156a01fe"
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
