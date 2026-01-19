class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.01.19.00.tar.gz"
  sha256 "803e7ed3980db0b760b748e68fec7e8e68ff605bb6b0f83b26274f2787011c08"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4f981517f2b29ec3677c9ddb47112db5c3a874936fab1ebf869c6c461ad1216"
    sha256 cellar: :any,                 arm64_sequoia: "2d623018f178f89697c5b458d30b44d4db4abc1f822d6ded5eecb378a425e2ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2eff728b93c649cef408b12e9cd446d51b6d8a8bcd837381644fa7c6a7b7ea4b"
    sha256 cellar: :any,                 sonoma:        "8899735b314440e8cb0e6fbcf20bb648568e81023146beea11a0bdf30c7769e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1221b89fad95e3ce0bb341a58c6bcafa1af27c76ae43390bbb01910cd014223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9519c02179114c91005296c14a3f2482139ee4ed52b1951342c469cbd2981f6"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "pkgconf" => :build
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
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
  end

  def install
    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.14")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_USE_XDG_STATE_HOME=ON
      -DCMAKE_CXX_STANDARD=20
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

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
