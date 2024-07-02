class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.07.01.00.tar.gz"
  sha256 "d56a1672802c5ea0b9b853a3a9d1dcf1644d72a56e5c6069db6319310b271d32"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a1a61b2f761e48658e52dd3e3bc28874915858de6f87947fa498638ccb90d83"
    sha256 cellar: :any,                 arm64_ventura:  "6367649b2d1836af3d92fbb720211af63c43d633b774a043e38566846fa19349"
    sha256 cellar: :any,                 arm64_monterey: "f27fdd773134ce08f96bab7f51cba1876f39ea07677b796aeca63c475e45a1f7"
    sha256 cellar: :any,                 sonoma:         "3d0521e5bc266b5dd521acf874ab4aa2189aa8b62ea6e0d76e077bdc5990dbdd"
    sha256 cellar: :any,                 ventura:        "528ac21cb38d76cd4c84654b0c93ca3b5f900db4ab7f0d4f36493e64f429c1ef"
    sha256 cellar: :any,                 monterey:       "6bbc0fb1433b31cb26ff9083dfe76d68e74fe17ea888340ea21decfdff11a6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2faaaf39fb0ce51d04034d641b46a044f4c2d03f58a19fc71b9e04d63a2b2e0d"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  # watchman_client dependency version bump, upstream pr ref, https://github.com/facebook/watchman/pull/1229
  patch do
    url "https://github.com/facebook/watchman/commit/681074fe3cc4c0dce2f7fad61c1063a3e614d554.patch?full_index=1"
    sha256 "7931c7f4e24c39ea597ea9b125c3003ccdb892292fc455b4c66971c65a48f5f6"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=#{var}/run/watchman
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    # Don't make me world-writeable! This admits symlink attacks that makes upstream dislike usage of `/tmp`.
    chmod 03775, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
