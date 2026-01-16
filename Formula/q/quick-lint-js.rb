class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 9
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0105ff78875739281d68a084a2e2758c54c1c984ea67de1eae5dcce6414808c3"
    sha256 cellar: :any,                 arm64_sequoia: "b185f0ee6a48613600a09ed7e1bf3b3b4911ed32eea0b6a0fc8df698c2f1d6ce"
    sha256 cellar: :any,                 arm64_sonoma:  "3de9423e6a160c3d355c84bc1f196569cd246343febdde91c3302188c3db50aa"
    sha256 cellar: :any,                 sonoma:        "01a124fa8367ed0a4b89524d5d8c001d93bf87f6479f6a21ba9662e1d2a76517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "718e296b58655067ae01de388cd33e3f748a54773fa87e000549c2847a1c1fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892f74b7f4ed3f69f32b4273ce65d8587d7480201734c95b35c2c18083e0c92d"
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
