class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.01.24.00.tar.gz"
  sha256 "037940c1a8a53a4fb952bd3bdbfbb57164dda4c78d7f54ea1d0603f679508ab7"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c7ce6510fc68dcb6d8d035c9e6b5751eb0dbbd42fceeaa6eb7d3a0b7bae5ecbf"
    sha256 cellar: :any, arm64_big_sur:  "62d05e7df2416c3ea01d61ffe572b7e1550b5b7504837c8473a3d341e6bce610"
    sha256 cellar: :any, monterey:       "0d92e2a3cdc1313266cc4044417622ac81e24782c9985e31c054842d325f506e"
    sha256 cellar: :any, big_sur:        "8059aab76ca405e3c972f220bc3a68c549b9a90a384681661b83ba0a5d1cdd67"
    sha256 cellar: :any, catalina:       "47f4dd81f9039b3a60ad9aedae496311dfe98cc1375b175a6371e2751f2f0c04"
    sha256               x86_64_linux:   "038135b005188b6f4da0f2729b2d12650e0eba607bb95d0010eedce00ec3430a"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "# t_test" if OS.linux?

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_EDEN_SUPPORT=OFF",
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
