class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7799fc5307fa3cdd32d6462169ba84a967c438a3f41c057a0f7847517ac5cbf0"
    sha256 cellar: :any,                 arm64_ventura:  "ea58fdacd0a84a9b2f135e6471bfa8f53e8887e493cc161df985222fa442035d"
    sha256 cellar: :any,                 arm64_monterey: "a1e7b1026b4e19a9940f3bff92fc4c911acbd2f3bb04d211ea8ff257f67d1e91"
    sha256 cellar: :any,                 sonoma:         "08a51a17990678b5ec7b74356675ffc501c1f1d8cbcc9732ca0730b62942a7b0"
    sha256 cellar: :any,                 ventura:        "dc7b6e322eeaf0f769cf232321360f2a425a920830ae7e35691498271837fd07"
    sha256 cellar: :any,                 monterey:       "8590fa28d0d897c15a3547fe79dc2410f049e00191f5f6e29c02a694636ed500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecea9067e1e5214c3b1b537282f92e07f940cb19ea8d447e128a7e2fa1887c0"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
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
