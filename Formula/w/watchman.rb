class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.09.22.00.tar.gz"
  sha256 "a8f6c90a4e7cd8612852b9a727b25f04487852ef96326617f3aa266698b4471a"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9f152945fec9cfb58126483b2260dfc6d5250b16f283bae2b5eac24356544a7"
    sha256 cellar: :any,                 arm64_sequoia: "e01bde0af4e34269e3c2fc6b39d842b2fd618ce6c51693dce3bdf4615a3efa61"
    sha256 cellar: :any,                 arm64_sonoma:  "47e2c8d294306bbf3c5fafdb2668ebfd3a954fe44cf82bca5e45607037c29ab3"
    sha256 cellar: :any,                 sonoma:        "f72978be5ede2ba0a88625a75a5c4e40cc3e6c30bc4e7f19874b4f9f6f86e4d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2087464b339a67f169df82cedd6e8881cfc68a11acc158a80d2f24ef99fb6a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "495a108f216d84cfbc775ee52ff365fb3792ce5dd9a8157f14578d9dc9259a5e"
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
  depends_on "python@3.13"

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
    #
    # Use the upstream default for WATCHMAN_STATE_DIR by unsetting it.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.13")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=
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
