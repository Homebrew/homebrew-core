class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.12.27.00.tar.gz"
  sha256 "2e7c79a8bfba41bf45f31d2fb4c06d7bb6d38afaeb28f5fb41695d8a09f253df"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "420c3ab025ca9dcdbb650a55b5523a9e381bc295f546b6896f6bf4c8ad213c66"
    sha256 cellar: :any, arm64_big_sur:  "679a31039bf51e01380e5f843edb0d19ac78100c90103e627c3954944fb8bf5a"
    sha256 cellar: :any, monterey:       "4102fcd79b980aff2c37d33f2295bda2ca24b9b01d01fbe0a0126aff05c4ab34"
    sha256 cellar: :any, big_sur:        "0006e1e71245068d4a5d0e2dc902792fc9fcd70bef7782a9cc921bf78725fc70"
    sha256 cellar: :any, catalina:       "4509e5c44ea02a20ac4062528a3b1326d5e30ee7b7b4f84223142f9a88e0074c"
    sha256               x86_64_linux:   "edc27a5c083ba22f8c53c30b0aeec9b991d63d94d8c7fdab2389dccb536d050d"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

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
  depends_on "python@3.10"

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
