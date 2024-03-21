class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "9f60cbcd6e1afb25b468a8f8f65a75c23b132c7fa2d336fbd9053879068ce770"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1eecfbf272687827eba7d0555b099d35a4278e019cf899d92cf85a86751fd609"
    sha256 cellar: :any,                 arm64_ventura:  "e45af0534fb2f60d4c7b96b1cf02bb8eb784a247f016c43204a36932c17f5fe9"
    sha256 cellar: :any,                 arm64_monterey: "13d38da48f9bafdf82a92070e462835a9fc7bc4183a6b86c2d7823ad6f8bdcc6"
    sha256 cellar: :any,                 sonoma:         "4b543c1a5e99e4819415c4946146f79d28bbc5df9f724878e4a4b9228d41f69f"
    sha256 cellar: :any,                 ventura:        "d77eb427aa6f55e9fb9b15974ac34a6733e0f1a7567558afa1f895d002bf67bf"
    sha256 cellar: :any,                 monterey:       "ef55a48cf03f163fc82b29189462d8dbfff5be99a37b5dfb614cadfb82f2ea51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c72d3db8f23efcc4c370e0c0590d8d1eea3a9c916f09d9476499a8ab61fe37bc"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
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
