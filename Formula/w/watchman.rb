class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "456fb61eacd9296bd452ef030b9727a1470933a31f326bdaddb52a59b2feef16"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9410b4b119812956ec5c064d97bd431d40819228fb796762ef4939cc1ef5fd06"
    sha256 cellar: :any,                 arm64_ventura:  "faa946e214d25678421fd6c4408f7d6887442bd3caf8c2e4341b1be965725bdf"
    sha256 cellar: :any,                 arm64_monterey: "eaa4dc834ad4a577b00a6577c6a78c51987c7ffae5f8cee1052c05df7c70bff3"
    sha256 cellar: :any,                 sonoma:         "d8488eb7b1189a56aecd3a20ad30317f135d7f72e1562e181802f0f5ce341263"
    sha256 cellar: :any,                 ventura:        "509d971921f135c36e21a6a64d0542f655ff495eb838dd99d4ef3fd59e161751"
    sha256 cellar: :any,                 monterey:       "95423e2cb2927a8b30d204258f53d15f1414ca0f0c24836e147863e3f529e67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24919bbc7c971be7fe37ea161ea4268604c67dcfe6435dc2258b2050cb4495c3"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "edencommon" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DPython3_EXECUTABLE=#{which("python3.12")}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    chmod 042777, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
