class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.09.12.00.tar.gz"
    sha256 "5143afc1641233839356c915b4361a1e097e3a56a326e1024ac2ae3ac419d4c7"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.12.00.tar.gz"
      sha256 "68a4376681c09ccf05f982fb74176bbc3de0785ac16fb62f6fb99bde3109cd8b"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4ef5b7605ceccfbca38c0c2323cd008878722e7708dbfc2121eea711b38d4b6b"
    sha256 cellar: :any, arm64_big_sur:  "b817a0f257cdb4898da97901b871c22ee5132519c2b9374afe126e82afac0527"
    sha256 cellar: :any, monterey:       "2591666d3d5d874383aa9da0c211aa5f94d46cb8d24248bc8da036e970781de9"
    sha256 cellar: :any, big_sur:        "ad0b28081391ce7ab62f27b4af8a0b4f011affa3db90f96ba25a50e5be819345"
    sha256 cellar: :any, catalina:       "786eef06713661bae57933a6d8ad3c1d45e6d7ea94f2a4f926ffd9b0c0acf97c"
    sha256               x86_64_linux:   "11a0e482405ed8ebc78ba17681a0f806ded764e5d9e2c2c66ba10f79577b431b"
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
