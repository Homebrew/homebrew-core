class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 11
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b97df029eb6d54f574cd72069c8bff9f887022244e082138f1c36cc0775be0af"
    sha256 cellar: :any,                 arm64_sequoia: "6323e99491b69439a65281751cfbbcbdd19f557fb244939074d08a68b3ad1ad2"
    sha256 cellar: :any,                 arm64_sonoma:  "8a36a0d2e8c813b752fb4963c1b21e0703289c3da9950b9a192a7425f4097364"
    sha256 cellar: :any,                 sonoma:        "575bf8923adbbaf1d4a9eb255ffa1ce3c9c54123c61016ceb63b0a73d6306cd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3570ebf2dac8dfdcfcafe516405208f58619056db10bb07cbcc623108a10b271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f811332bcb48460400f8a371bf70e6a4202b9f71432a47b488a9fcf527cef2"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkgconf" => :build
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
    assert_match "E0034", shell_output("#{bin}/quick-lint-js errors.js 2>&1", 1)

    (testpath/"no-errors.js").write 'console.log("hello, world!");'
    assert_empty shell_output("#{bin}/quick-lint-js no-errors.js")
  end
end
