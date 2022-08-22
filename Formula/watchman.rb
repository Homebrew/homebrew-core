class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.08.22.00.tar.gz"
    sha256 "a1fb9b7f5dd58c7d62261c82a9645c94ba350f806ebe19dd3ff14385e59a9f40"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.08.22.00.tar.gz"
      sha256 "3ee98e6be475f9ff15a0c8e91b77bbd3afc3eaf74c26c6e5e09b9e3340a4b330"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7e9498684f79a64c95b7281475f63d146309dbd8254b3f5d3d373efda1d583f6"
    sha256 cellar: :any, arm64_big_sur:  "42f1a551422efcfae0aba3255f8b2718b45f46eb6f0879b1e9d76858cd529dcb"
    sha256 cellar: :any, monterey:       "dc7cce33bd70bcbe0ed266cec31c1467fd5fba6d72dcfb79589c6e06aeb78be1"
    sha256 cellar: :any, big_sur:        "ac18d89c1d0cb110543eba6334784b19032fd0fddb90f6f08b24b34b576b2dbd"
    sha256 cellar: :any, catalina:       "8b19c60ecd5bf5b795b6a400283c4f17a76f8168065461682b08c28587056974"
    sha256               x86_64_linux:   "9b510ac66a5176ba413bdac26778472cc2cc052b845e9decb282d00e1b4170e1"
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
  depends_on "pcre2"
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
