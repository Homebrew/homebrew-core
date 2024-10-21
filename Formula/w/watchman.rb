class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.10.14.00.tar.gz"
  sha256 "66539e51cd05ad450085dd811fcdadde9c55286509cf77b2d463e703d6da84d5"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e3c7a95706c08c2d3938d9d17851b8fbd43f63ac75b2408fa80676c1a499b3d"
    sha256 cellar: :any,                 arm64_sonoma:  "d8414e582bf33e7a4438ef800752bb415eeadc8e4c582d4f24a9a38d2aeced7e"
    sha256 cellar: :any,                 arm64_ventura: "253658df039361973336a0f4d6c650b020f4fc4a2c261b4f2ac427633ed3244a"
    sha256 cellar: :any,                 sonoma:        "be75889830e3548db46792b5233e7325cf014b166ca42bca224d85c58c6f2f6d"
    sha256 cellar: :any,                 ventura:       "f8bf248b8a075aff53119faf064835379c05c3416011f65713e2c3e0101e2d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f32f1da49d0376d4919b92c4342945504eab1894263c5a84afdf0217aa9136"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.13"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    rm_r(path)
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
