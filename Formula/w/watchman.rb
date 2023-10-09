class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "f7e92f4007c151480f91b57c6b687b376a91a8c4dd3a7184588166b45445861c"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b260ef8c6405e245bc81c379484802d4a73a4acf956370d605080ba03ebf056c"
    sha256 cellar: :any,                 arm64_ventura:  "7c1ff98949395ad3da84ed36543bb45bb2b5522bdfa07da30bb1cba6ff284849"
    sha256 cellar: :any,                 arm64_monterey: "8c4fdb600a5fa453bb26a682caa7c1a6efd698bec641953a459f1f99af0a45bb"
    sha256 cellar: :any,                 sonoma:         "215ed6e496a6288b2d0716c7f05b4a8fb1de4a1130b6145dc40c8f9395aed729"
    sha256 cellar: :any,                 ventura:        "9fba8d481f96efb52a9d00688ab0e9733c764304db520547a6073b5623cda295"
    sha256 cellar: :any,                 monterey:       "413aea41bddd75af521b7beaaa04d4052f77535f1eafa6cf12fb63f5c8992749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2a79df110dd0dc44b43a02b750a4790ecff952026423cd624e052bf2510258"
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
    python3 = "python3.11"
    xy = Language::Python.major_minor_version python3
    python_path = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    # Make sure to pick up the intended Python version.
    inreplace "CMakeLists.txt",
              /set\(Python3_ROOT_DIR .*\)/,
              "set(Python3_ROOT_DIR #{python_path})"

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
