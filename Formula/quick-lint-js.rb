class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.14.0/source/quick-lint-js-2.14.0.tar.gz"
  sha256 "b7420dc6a09a4d713f666f1cebf0285c25ffd67da1e167a4dcfa8572ffde2bfa"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5ec3083a54b26942ceeaf66f7f46c722a2a51fda37caa62d492b96e834ba0102"
    sha256 cellar: :any,                 arm64_monterey: "b88978fed37438832972d81ad2542641720d627ae7e06d0ac58054419448a4f7"
    sha256 cellar: :any,                 arm64_big_sur:  "3c7e17814f1f7daad8d8ad6f30f8923b1fa1b702ff6d52066f4118fedf51323f"
    sha256 cellar: :any,                 ventura:        "8b9bf41816a06763fd5e331b29e695e3a0f877b8478cb61cd4b63d214c5afd44"
    sha256 cellar: :any,                 monterey:       "480f54eaf8db4b4f789c49a32573ef5c3a64d0764826de7da318844beb2e18a3"
    sha256 cellar: :any,                 big_sur:        "534bbcf7353307f96e275416430bf6262d19d238b0b9340ac060e3468bd5563d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67c33c9973e480181652a4b36665665f57e74a92a2f84d24bdadf83f1600348"
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
