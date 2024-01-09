class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "fea21717be1d3e57b4dab4b25e88592c3c2228b5b425bf34173193fbc4736e19"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "71ba771348e2bbcff73f79dc7d671bb68c97a5505286c5b1ee75fd38ff59974b"
    sha256 cellar: :any,                 arm64_ventura:  "b4fc3efe5d6901a61d4b39e19f36463e683bb79d0d5fcb8cd269d5dcea0971cc"
    sha256 cellar: :any,                 arm64_monterey: "367153c209b088e818ea5efedb7e2e3724124080dead65fde8165a37e5b3a6cd"
    sha256 cellar: :any,                 sonoma:         "5db2d4c8332526e1e596c959d147e2ef6793517536d38f40926eaf003e20a713"
    sha256 cellar: :any,                 ventura:        "8467f3ba14225f3aca240def454a71d98749acface02bc0548d1796171907aa1"
    sha256 cellar: :any,                 monterey:       "b7350773a66ddbaba0c720dc379dc7410488fe34404518d2ad1665e34bde9e42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b49a58c8f934acbf197566eb9f728396d424559db23d45b4f9cf4cb97bc66c"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "fbthrift" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

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
                    "-DPython3_EXECUTABLE=#{which("python3.11")}",
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
