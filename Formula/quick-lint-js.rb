class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.4.2/source/quick-lint-js-2.4.2.tar.gz"
  sha256 "c52f961669439ae13e9676d471118f995baf46279da70ac0a7c98c4aede925fd"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89a1773ca9906bdde6449170f7c1f1dd49361f2335a9f310cd42058662e0f860"
    sha256 cellar: :any,                 arm64_big_sur:  "b06bd33d74a281673276b1713de5e3fdfb89f5574a42b1837d0639f5344cce80"
    sha256 cellar: :any,                 monterey:       "acefec368522b6d17d21a3fa780e197eeb5d305d6d8db64095ee5418a5a0cbed"
    sha256 cellar: :any,                 big_sur:        "cba4ae88794eb5dc71568135e85593ab1f1c043f4851a9ed5379f6029da12e37"
    sha256 cellar: :any,                 catalina:       "22a563cbbc25c78dda6896ad3689de97f7f45986483d699f1c557c785fd65e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b6994fbc6b784a77899e6b2549af29ba391c5a12c26befd65b50af115efd63"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "simdjson"

  on_linux do
    # Use Homebrew's C++ compiler in case the host's C++
    # compiler is too old.
    depends_on "gcc"
  end

  # quick-lint-js requires some C++17 features, thus
  # requires GCC 8 or newer.
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"

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
    chdir "build" do
      system "ctest", "-V"
    end
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
