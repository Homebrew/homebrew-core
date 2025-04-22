class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "22f5b01de393d987ab548240c96e431ad674f3370e77689be3c73348c569af8b"
    sha256 cellar: :any,                 arm64_sonoma:  "6201363defa25543f5b7fd1cdaaf326f9a9ad3854413daaa083449ee1315ffb3"
    sha256 cellar: :any,                 arm64_ventura: "2f756eeb26e05573ac69db780c82831f594c12bf36ba194cea767de422b46628"
    sha256 cellar: :any,                 sonoma:        "4939daaa3f8d302bfbb3b3061e95b94c33b5b105956bd8190f4916ead9c77369"
    sha256 cellar: :any,                 ventura:       "c77cb4db725fe78fa82cceaead890b035a6c05d89e133e9897935919ee2713c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e38faa6ea5b9c72ea1975dad60629e8004aa7fcaeda07acff30f86b72227101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec9493f33efc20dd88dbd4172ef4dc1ecce5fc7b79396ce048b871a7ee55f09"
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
