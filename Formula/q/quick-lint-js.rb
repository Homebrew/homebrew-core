class QuickLintJs < Formula
  desc "Find bugs in your JavaScript code"
  homepage "https://quick-lint-js.com/"
  url "https://c.quick-lint-js.com/releases/3.1.0/source/quick-lint-js-3.1.0.tar.gz"
  sha256 "d5f133780ebf8735e4f6e4c8fafbf04dd7a7db17cd2c31e899613d5bd32d0b1a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/quick-lint/quick-lint-js.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "06a62b7ab4aebef993e264128267202bd3cacf76399df659bf4e91d501fb7533"
    sha256 cellar: :any,                 arm64_ventura:  "8e06ec2c1cdd16db58d216b300b136fc1c99373e74e992d656c6771a42c4b225"
    sha256 cellar: :any,                 arm64_monterey: "a5633b69fef163229458ad2a079f8bd01f101ec01d7eb03ddff4ba6a97a6eb34"
    sha256 cellar: :any,                 sonoma:         "df5cc8247a493fb5b2d295c0cd789bd1504c27da40fc671bf73225db95e17bba"
    sha256 cellar: :any,                 ventura:        "dd34fec4f228150e4d786eb5d0ed16a6dc8b39b6cdad90c712d3c5231eed8159"
    sha256 cellar: :any,                 monterey:       "46aaff9b6d11a18b3a091eb1902fca89739963cfec168f9b7d6588856e1d723b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffa5ede5364c2eb266b01629fd717e178ac987ab54bb00051a9f457e7e31c22"
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
