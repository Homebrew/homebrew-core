class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 6
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc2bcf04b29c7454a5614d5d19d65160a91887f24abbb6192c58c3160eb9e8ed"
    sha256 cellar: :any,                 arm64_sonoma:  "3a4c1ae85e662c20ab6fe90671708b5f7908bf99a9fdb8b89963002c110586b2"
    sha256 cellar: :any,                 arm64_ventura: "40d423c74c392ca76e3aa44cbdb5e67cea17a6dfeefa9ce7830fd6c5588f3d40"
    sha256 cellar: :any,                 sonoma:        "aa2023ec9fcfb5c3065c519d2d8f3d8f6794b7268308df714e03b65aa6797979"
    sha256 cellar: :any,                 ventura:       "835b11499e7f1ac54eb876c2381921dbbe85d27b18d049416645e9e16af2c178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8afa99b5efff7f2968f354e137998fc9cf44a6b941350b8e7d9200f1d3ba213f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d902e6b80322aeb5a13684ccab9de0e7e70dde9829f3dd8a58d44e82487035e9"
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
