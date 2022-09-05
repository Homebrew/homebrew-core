class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.09.05.00.tar.gz"
    sha256 "12f6665528acdd4bf6b544ffe80ecdc769eb70d4e107379c0216dab8f0272f20"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.05.00.tar.gz"
      sha256 "d7c856ec21b0630ed48c6714c5b8e692f10d8d027554b11aa0c3117d84a2c318"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "bdd498743a8de1440588e8c2421eb69439b4e59d8bddaeb5fe52f6da18d43255"
    sha256 cellar: :any, arm64_big_sur:  "613fccb1fe39347ed72dce346281b68e53ab509b6cbbc3654466a319496e08b5"
    sha256 cellar: :any, monterey:       "d2087a66cd81a61643c8f3a53b71bf1c32ab17d003644bffb30ad2f488cdd5fd"
    sha256 cellar: :any, big_sur:        "0a68dac8260b3b27553226b81cff39f8bf9a3a6536036b794e071e04f329a5fc"
    sha256 cellar: :any, catalina:       "4ebb9de4d9adb31ac30674c4e8dd011b8adaf2601418be60ebcea90e0ea35972"
    sha256               x86_64_linux:   "1970a14b5478a90ba2072ee2f9e046d0ac39031644012f025a46d393db23a14f"
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
