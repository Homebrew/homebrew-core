class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/2.5.0/source/quick-lint-js-2.5.0.tar.gz"
  sha256 "298ed4287f187de198e428f7d4c239b0a56f8f65f5738a57330c3db9d98b26cd"
  license "GPL-3.0-or-later"
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c33fa86547eedf264cd6245d37c80c5475aca445330edda1be201e5b0bc3129"
    sha256 cellar: :any,                 arm64_big_sur:  "55e74d1f115ffe2253d8387ff7bd063d82d2a096bf610d5ea7d213e973cb2469"
    sha256 cellar: :any,                 monterey:       "b6ade80becc504873bce87a37db1cc82d8937bdfa8734c7ebf38a0fc184b714b"
    sha256 cellar: :any,                 big_sur:        "6a268f758e873f303c0afb01038737d9004f97373e72f30b708dbefdfea50d43"
    sha256 cellar: :any,                 catalina:       "b339a07452157fcb0d960a2299f9eb3eddf359bd5f39d82b4f451c775dc04d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515feeb50587473133064c2e1a1ba70fb55add18d4e853e977bab46b1e870be5"
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
