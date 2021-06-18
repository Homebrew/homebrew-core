class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.06.07.00.tar.gz"
  sha256 "d5e1e8f4812f0ecd58c108f5844de726a0701bd5dfebe04c4f2a6c61dda0b256"
  license "Apache-2.0"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5ccd1074a8582a6e171bcb76a4588d16d3c0a6ede015b2f7a33d214393708800"
    sha256 cellar: :any, big_sur:       "22fb0d7442a9b36f66861a04b9401c40b9e106401914cbff3e164c988e52595d"
    sha256 cellar: :any, catalina:      "b7702260bbebfe18540d3f860069a043b94cea5b7743b743a2a8dc8a8d36bdc3"
    sha256 cellar: :any, mojave:        "2ccbd0df37dd9c81283a137259cfed579b5c8c6596914849f4feabd2adadd0f5"
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
