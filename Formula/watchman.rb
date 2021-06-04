class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.05.31.00.tar.gz"
  sha256 "0bf447ba180bf7baecefcaa154eca73b0661b0b2c6162a8b010af8ef08e8ad18"
  license "Apache-2.0"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c3c035ef3a75a7ac946875126d2d1e1f831e30930e3aaa2c26888aa112f42ecd"
    sha256 cellar: :any, big_sur:       "2e621ce625eb92b220e5a67446ccb09b9d06d4920b34d526cfd027a35fcbd03f"
    sha256 cellar: :any, catalina:      "fc23c7c148a217a82da6de5d7fe40125dbf033072a906a63d4e71025003c1de3"
    sha256 cellar: :any, mojave:        "8ce6f7de265228200cc01bbf47d0f9004ec6d3e67dc71bc142d749b81d9e5114"
  end

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
  depends_on "python@3.9"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
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
