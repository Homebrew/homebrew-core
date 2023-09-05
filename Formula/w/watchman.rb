class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "39f70aa1c7bebcf8c84cd1962f4a1066f0615f16283e80c521d9eab2b7aa0fbf"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98a5b00a01cb21c1c141cae4b62a1cb3088548494767fbeac506d5a490c49e8a"
    sha256 cellar: :any,                 arm64_monterey: "ae6ead5abf278b86c587c45694313a650fd7aa6010c6508d2e18f9908449f651"
    sha256 cellar: :any,                 arm64_big_sur:  "1809c90598ef3c89dc06ccedb09caa77466a6b8da7828e6cc1116df38c472e11"
    sha256 cellar: :any,                 ventura:        "eeed6ac43d5d66db3da9c42608a5ae20115dd529bad7fd32d09e1ae16ded60bd"
    sha256 cellar: :any,                 monterey:       "b063bd0b4af4d0306d11166efe0898c43f4c4b29e87256d6adf23913e32f6608"
    sha256 cellar: :any,                 big_sur:        "60d60b7bfe47f19d7769847d40c6b09b25459369f32d87a67d0b3b369acbdaba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3a20a6c141646d635afa435d5039abd7d8af97c32a46464ad7918d1a3db661"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.11"

  fails_with gcc: "5"

  # Add support for fmt 10
  # See https://github.com/facebook/watchman/pull/1141
  patch do
    url "https://github.com/facebook/watchman/commit/e9be5564fbff3b9efd21caed524cd72e33584773.patch?full_index=1"
    sha256 "dc3ef949b0a4be7dd67267eb057fb855926b3708e0ce1df310f431fd157721ca"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

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
    system "cmake", "--build", "build"
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
