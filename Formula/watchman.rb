class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.02.21.00.tar.gz"
  sha256 "8bafc51e97aaca426395578d53ef5ffa9a66efa5be129d081f5393613908d2ca"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a17cb20e09f964505dbcc8ce690252bafdb699444c295bfd05ee2edc1a110db9"
    sha256 cellar: :any, arm64_big_sur:  "d687120b74f8097c9d9be56220464f2b48438aad3069d8f36755e1b4a12167aa"
    sha256 cellar: :any, monterey:       "0e69c1317cc15cee2ab026bcaa1e07f0f0d578e0a4f2228ac83e18c5d7a810d0"
    sha256 cellar: :any, big_sur:        "9b0437d417a213862cf0f268b512762002afbf01c2a8d3312f4f8a33fe610a83"
    sha256 cellar: :any, catalina:       "b74bd7a2fc852fc8978940591bd0d13d93eece6be1d5f6746db529e07552913e"
    sha256               x86_64_linux:   "d23dbea274bd72952221032f011e22ff8894d57efe6aa2be137c028395c4d1a6"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "python@3.10"

  # Dependencies for Eden support. Enabling Eden support fails to build on Linux.
  on_macos do
    depends_on "cpptoml" => :build
    depends_on "fb303"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_EDEN_SUPPORT=#{OS.mac?}",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install Dir[path/"bin/*"]
    lib.install Dir[path/"lib/*"]
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
