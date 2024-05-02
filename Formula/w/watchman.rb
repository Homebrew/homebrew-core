class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "ee0660e6c5f795a2c5a1e541d460244517a296d2274f50c741d3f3196c64468e"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b77974d128ccc440053e6f7ef5a6dc11a7ef0435d537fc4adb0cba830136de4"
    sha256 cellar: :any,                 arm64_ventura:  "d50357e7b44c800c253e6d071cda8cdd447425ce44f5aa7779e7aaf82bc5d7ec"
    sha256 cellar: :any,                 arm64_monterey: "30ba97dffe0072afd1a4e4a7b994d49bfb9986df94be636ad31c58d16e210098"
    sha256 cellar: :any,                 sonoma:         "25a8f64140819bf0e9af39e58d87fbc2a59d81cf3b29b5bd530c6e03c7627d41"
    sha256 cellar: :any,                 ventura:        "ec72f55630885b46bbad14fba9e8ad73fe487e2dc01abd39292f3d8263fb1498"
    sha256 cellar: :any,                 monterey:       "0a7167b077dc61204cf118bb01ec9680e4854ce0f5a1916a179b85ed9d50159c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77c6488d07c09ff90742c8280ef4ee6f046d34a16f0bb400ae362940206aed77"
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
