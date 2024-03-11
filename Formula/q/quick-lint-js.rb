class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "844343211388795f7b5c3cd937af323496f0eac0332f947b40665932d3036f37"
    sha256 cellar: :any,                 arm64_ventura:  "2bee4e5f45807a339ba9cf5fa66684f76f2950ea962f430abf09212dc12b64a9"
    sha256 cellar: :any,                 arm64_monterey: "ca6990d3067bea3d5b8586d1828d869fbf7e1695139f378cfa91d7f2eb98d27a"
    sha256 cellar: :any,                 sonoma:         "2c2ff9c88641a31351db923de8b2fe146e3abe81572d35370fc55716db8f7a96"
    sha256 cellar: :any,                 ventura:        "5d729c95820f88d9a3fd9fc8722da6c212aaffffd4589a5109cf294ba55a1891"
    sha256 cellar: :any,                 monterey:       "93fadb5df66c69df215288fb310721fd7eccfd433fe0981877e75afc3276da83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fd354f4189e5415369198300483d272acb2a7b197d33044eeb375fe9b51da10"
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
