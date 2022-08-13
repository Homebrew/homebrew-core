class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.08.08.00.tar.gz"
    sha256 "216cd998559f1799012c362468e4e8cd7beadebd71aceb4c2d1e475770ce72a4"

    # `edencommon` currently doesn't provide tagged releases, so we just use a commit
    # around release time of `watchman`. For example, we can use the `edencommon` commit
    # that updates folly-rev.txt file to match `folly` formula version release commit.
    # TODO: Once tags are available, either switch to tag or create a dedicated formula.
    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/d356bb7a9a28f09f00d72a81f7b60f8f27ce249c.tar.gz"
      sha256 "d5c5277bb697f131abd591d52d8b9cb905309d516fd767a4d6cdf3b156659060"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6528685f888664b05ddc225ff38b0664923498a5eb29fe1bae459700c8f2b28c"
    sha256 cellar: :any, arm64_big_sur:  "167d1faf6522685afd679a2a86bf88eb5cb4ab228b54657598c53bf1969202c1"
    sha256 cellar: :any, monterey:       "a6e012c781d87347e494a1307baed01c1fd2e137ca59139f65ef6920aef5f4e8"
    sha256 cellar: :any, big_sur:        "76698add0cf1b6b44387d53d663c20cde948293a1b979e887db7d4ee3e11defe"
    sha256 cellar: :any, catalina:       "1ae461410f098020eab4619edeac23ae1884002b372595ce99a7015a2948184c"
    sha256               x86_64_linux:   "383478cb9e47eadee9bea433cc268f4173da4293c83fac5e6cec3d07e55f3319"
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
  depends_on "pcre"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

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
