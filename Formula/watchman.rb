class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/v2022.10.17.00.tar.gz"
  sha256 "54d2f454e49cc1c44fe5b4712d9f6b38a86323817c8185c66fbaf951c9411f33"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b18a9a11f60af26440ad0aec6c74a1b59fe9450952a422d60eb0442c902f518"
    sha256 cellar: :any,                 arm64_big_sur:  "38bfa2efb1938b6314b246dc4562b328d8d34823871f69326b6b9e4c55b7d6f8"
    sha256 cellar: :any,                 monterey:       "bd4f42e4813a4f3afe35c0231fc10fa37bcbeb319b4aff9265079d769148e2f7"
    sha256 cellar: :any,                 big_sur:        "251b0ce9397be2ecb140c0788d348b868d1fa1ff8fb58ecd47821e9a3c7746da"
    sha256 cellar: :any,                 catalina:       "8fbd611c3baa78ea11c4f45b8a3b78413ac499d18d10367c1373943929bdf511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b73c8c6cbd080594c2640a56b85b2be9e4f408a556f5bd2df387a553c64a66"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
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
    # Fix build failure on Linux. Borrowed from Fedora:
    # https://src.fedoraproject.org/rpms/watchman/blob/rawhide/f/watchman.spec#_70
    inreplace "CMakeLists.txt", /^t_test/, "#t_test" if OS.linux?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build",
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
