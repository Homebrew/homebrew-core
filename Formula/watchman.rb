class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.10.04.00.tar.gz"
  sha256 "3b7a1455baeaf76abf775402f4c045c0be1b33bc7834eb499fa5e187e2aec72e"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fac18c60841c8932fa525a6d78dd3e7c1fabd87b7b9c4e30648d923e3c775039"
    sha256 cellar: :any, big_sur:       "7bdd5da42a7d12a696f27773cf63ed76777f3b40e8d8ac4c254b93e01399b5e6"
    sha256 cellar: :any, catalina:      "2f8a0366213a5e83644cdc62280189b1b256093c53348ecc504f8ab0af188242"
    sha256 cellar: :any, mojave:        "4a0703e0fda0541cb33d57d97991a1cf248914c738610a013acb6fbb5e2d43e8"
    sha256               x86_64_linux:  "91ab2a23e4b3aa4f70f26c41fc18ab13d287ea41c44f49b9cf09b921ad1c7353"
  end

  depends_on "cmake" => :build
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # The `googletest` formula (v1.11+) currently causes build failures.
  # On macOS: watchman_string.h:114:16: error: no member named 'data' in 'watchman_pending_fs'
  # On Linux: gtest-printers.h:211:33: error: no match for 'operator<<'
  # Use https://github.com/facebook/watchman/blob/#{version}/build/fbcode_builder/manifests/googletest
  resource "googletest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    resource("googletest").stage do
      cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
      system "cmake", ".", *cmake_args, "-DCMAKE_INSTALL_PREFIX=#{buildpath}/googletest"
      system "make", "install"
    end
    ENV["GTest_DIR"] = ENV["GMock_DIR"] = buildpath/"googletest"

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
