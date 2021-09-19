class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.09.13.00.tar.gz"
  sha256 "90c417f3f96e31e7e18fc5ab0824f929ad081c81d03315e6e2288c73c12be602"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0469783ad9004cd7d15ffbc98296d4602acfa687edf42573f80c490f92fc8a76"
    sha256 cellar: :any, big_sur:       "97b0f6fdae5dd397f21a0465d42f5e4b604f3d76e8e5ca5457c45c716ef37af2"
    sha256 cellar: :any, catalina:      "2f479d54ca4766af51c9912425df717683e0114e846870778b0b77cfb9a5ab57"
    sha256 cellar: :any, mojave:        "d71f324f04976e5e0cebafb25d90501ea67c56cee4e519a7b51bb52bbe472a46"
    sha256               x86_64_linux:  "d994e9410b5c61edced71716e841a3de0743a279e604b402689a01a6870b4322"
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
