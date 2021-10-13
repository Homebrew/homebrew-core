class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.10.11.00.tar.gz"
  sha256 "d2a875617adde0eace774299e3d049f1825975cfdcdb4ad78e6b8e3f69a567ae"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6df86994371421056dbad95186df2a01f17a20ecef58725903725de7930c8ff4"
    sha256 cellar: :any, big_sur:       "57ef39d7d5c7ce42008456ea37844b7665ef233c82dff64902ca866b7a0a4411"
    sha256 cellar: :any, catalina:      "e7f27d66b477bf4a547114ba95cb7e110ce502cb3b2e94e97c37b68f7cadab06"
    sha256 cellar: :any, mojave:        "51ff176074996d008c672028ef93cd40d8be62a7410f8f85398282473101c632"
    sha256               x86_64_linux:  "d2c45cf289a2a581a22f0ca9893abb1202c2144ac59e79ad848bbce15397c0d3"
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
