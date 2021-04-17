class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2021.05.31.00.tar.gz"
  sha256 "0bf447ba180bf7baecefcaa154eca73b0661b0b2c6162a8b010af8ef08e8ad18"
  license "Apache-2.0"
  head "https://github.com/facebook/watchman.git"

  bottle do
    sha256 arm64_big_sur: "4a44a39cfd719b34d146043aa5afcc6ac304ebbd2ff4ff0fb2e37e22871f38ac"
    sha256 big_sur:       "f03c91e17cd7595f98106ee4a27f28433ecc2fd6dde8cc1b7e279bd60b730051"
    sha256 catalina:      "30ed7115aa2a2534f5255508915f827c2e6f3100fcd7842415db64e31eabac30"
    sha256 mojave:        "135eb0a8f098417a8e4d67bf8d732a19bad1932eee085497877e93982e91074f"
    sha256 high_sierra:   "e872c3aae64c3b78197de9f12e272bebd5d20c316a120916f59a5f1cd2fac039"
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
