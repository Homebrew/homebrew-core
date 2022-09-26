class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"

  stable do
    url "https://github.com/facebook/watchman/archive/v2022.09.26.00.tar.gz"
    sha256 "cc7c5f5a7d74383e1e360c373b3a1b973b95851366168392c297ce440e108fd5"

    resource "edencommon" do
      url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2022.09.26.00.tar.gz"
      sha256 "1fc2724a346f27f01007a9e4f695460437788903d326ebbb52f874c98e7052b5"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1a46dec3f355f1dbc4572b79ffe1f7db26f5627dec5c5f48e29278af1edc51c3"
    sha256 cellar: :any,                 arm64_big_sur:  "d9ede6526c5257a493464552ff656c5f465a0baffeda6e71973eccbada44e138"
    sha256 cellar: :any,                 monterey:       "51fd827e8841d9e2c1a8401084c40053f7a404cf22428eb8fbb6ff1bdef81ceb"
    sha256 cellar: :any,                 big_sur:        "e7221cfcf0a156e762fdecbef77f18589696937e83e7cc364ea9493a3c3baa31"
    sha256 cellar: :any,                 catalina:       "d2f448e045fbbc7b3047e7fa72de14b44c3ff346a76957aa975e10cd36d5139e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e181cc7c011b1bd452ec220e01dde8ca3dcfbaebfa1fa66ac9a17041ea06e44"
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
