class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.05.11.00.tar.gz"
  sha256 "53c3e5e63fd2ceccd2f9469832dc18b69c62175e91061b2da2fd27ea5c5ad51e"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fdaafe6fac9b3d2a40ee6db46338f77df481ce9d8de275293a99f28275966e5"
    sha256 cellar: :any,                 arm64_sequoia: "71e297ee118f8e81ae83eccde72103e92a5c5ce5eb17f6bd5dd6477b592c6312"
    sha256 cellar: :any,                 arm64_sonoma:  "b02b57a9d51114775aab62dbe587ba5c08b76189240c91864dfa403da4c00f45"
    sha256 cellar: :any,                 sonoma:        "5e2e511c9bd0d56e63f989f38fb5db386666aa970b962b0b01b55d2fd90bb269"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "284e63aeca49e2a6d0751de89aa267cb3d95f0454a22d8d2e7bbd9c28888acae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0aed934e884390d92bcce5bbe1f42af375f0f1d300c5f7a2db493b66c323c2e"
  end

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "gflags" => :build
  depends_on "googletest" => :build
  depends_on "libevent" => :build
  depends_on "mvfst" => :build
  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "glog"
  depends_on "pcre2"
  depends_on "python@3.14"

  on_linux do
    depends_on "boost"
    depends_on "libunwind"
    depends_on "openssl@4"
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
