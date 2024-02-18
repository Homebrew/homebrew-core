class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.05.02.00.tar.gz"
  sha256 "32743a7b142a79da8fafcb034f19212b3541c57faaf38c31407f9fad3fc9d646"
  license "MIT"
  revision 1
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47a4d738dba5316109ba4c3b13e203fce10e0f015811931173c9165a8ccc6a2f"
    sha256 cellar: :any,                 arm64_ventura:  "dc5b6fd56fe4f64ccd0f2b12e60b3426680af56acd1ecf1de4c76c57a404bdc2"
    sha256 cellar: :any,                 arm64_monterey: "ac272ff55972d6dfe664bc39d5aba4cb01e455f871470193bc48017b4aa73d36"
    sha256 cellar: :any,                 sonoma:         "f5c70950313db2800b369115bada162abd63b647644cfcda8f672c18c622c18c"
    sha256 cellar: :any,                 ventura:        "90e98c338e3f21c901a80500473e0267aa9c28e12c6414b3c00e5e34a7caacb7"
    sha256 cellar: :any,                 monterey:       "ede7bf79674f549eea3447ed61fd8c4d55c4e1df2379629d94d7fece13246825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2de32dee9b25f570e71df20d3d37d03e3843db25df4d56e52980d8e33c3a81b6"
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
