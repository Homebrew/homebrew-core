class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.09.19.00.tar.gz"
    sha256 "2f85a30434f889222dc10fdb7921b9f0898b0dfcb0dec18cdef224c50834e302"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.19.00.tar.gz"
      sha256 "66a51e14fceacbf84fd1e0e5ef5499c3b76de6a9125a9ad0e75fb84e830e3201"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "562c666261479a685bcd8103db1377905f9c90ce05c1ca84d3b0daff47ae1b5b"
    sha256 cellar: :any,                 arm64_big_sur:  "e7cfb8e47919add563a904be6a6ac2a4b1bc169e643c808b546ea4b3b0f91aee"
    sha256 cellar: :any,                 monterey:       "97bf90089b9ce8ec88c6a5d7ee88d7e766c4346b6e2c854ee2f16e9282564deb"
    sha256 cellar: :any,                 big_sur:        "3f84efba90fc0040e63a1b92118fda55aa62c95b575beb7d55e656d14d20909e"
    sha256 cellar: :any,                 catalina:       "2941e6a752f621de99184359a1a9b66b740ad59e99d98d1decc6190b4ff19484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b2a541a7b9ab1282af70bd71ea06a1f396dcc77e18221f282c415c8f0d9227"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  head do
    url "https://github.com/facebook/watchman.git", branch: "main"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon.git", branch: "main"
    end
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    resource("edencommon").stage do
      system "cmake", "-S", ".", "-B", "_build",
                      *std_cmake_args(install_prefix: buildpath/"edencommon")
      system "cmake", "--build", "_build"
      system "cmake", "--install", "_build"
    end

    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
                    "-Dedencommon_DIR=#{buildpath}/edencommon/lib/cmake/edencommon",
                    "-DENABLE_EDEN_SUPPORT=ON",
                    "-DWATCHMAN_VERSION_OVERRIDE=#{version}",
                    "-DWATCHMAN_BUILDINFO_OVERRIDE=#{tap.user}",
                    "-DWATCHMAN_STATE_DIR=#{var}/run/watchman",
                    *std_cmake_args

    # Workaround for `Process terminated due to timeout`
    ENV.deparallelize { system "cmake", "--build", "build" }
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
