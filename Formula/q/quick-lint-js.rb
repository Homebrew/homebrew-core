class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.2.0/source/quick-lint-js-3.2.0.tar.gz"
  sha256 "f17b39726622637946136076c406e89d3a98ae363d5e3c2a93ab1139bf0e828d"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a01d77385e35693b39d0d6b53bcedc80e451adae99c17dc7736f3c1d0dde676b"
    sha256 cellar: :any,                 arm64_sonoma:   "1c699e9d0d9055c43969f64b41b42e747b072e65e84b758d02ae7997c15e353e"
    sha256 cellar: :any,                 arm64_ventura:  "5cd781a6b0b50689f316ee6d27d503ec4343bc63c59596828f46867304b4ee76"
    sha256 cellar: :any,                 arm64_monterey: "69ee58c007063145b36659d42a4c3fa045caabecc20e2a9b4254aa039d29f53a"
    sha256 cellar: :any,                 sonoma:         "8a1bc3c66806e5072d5eda62708201d7b9a29028f2152d084f23fbb52559f48a"
    sha256 cellar: :any,                 ventura:        "ec13d355b3a67bfac798e9afc7fe35cd316ee06a568e031e0d73da957b5ba7cd"
    sha256 cellar: :any,                 monterey:       "586efbd26ac2d272a193fde740c9c626a46fde8b71b8d911b55ae6307b9cf454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62079260e74d945d2d2a9f6a23c98212df617e295ed30adfb35c95b43cc7676b"
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
