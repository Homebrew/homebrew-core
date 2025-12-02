class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "b40fcd0daa648baa704baf3b0aa4e998ba3b2ff4f109f9b89ec0afe48f6aa06b"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "d1a32fd302da19e696868842e7957e011ceb985dd7c9dc10949a6f28f43b7ca9"
    sha256 cellar: :any,                 arm64_sequoia: "6b8b7452fac915f02d5653de01b5ad1fd9c19a915c6be462162b0cd70b5af239"
    sha256 cellar: :any,                 arm64_sonoma:  "c42c94f789130a286eeba06d16357132279b64918ddfd1157f8dd4f755ee875e"
    sha256 cellar: :any,                 sonoma:        "dea8efd977f4ae03620c16716020c964938ed09bc0a26c23e5f111e66a2d6276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5674efea8603c96b7fc453de55b919f1ca5c5f498cf8335b7eb590e9b850e16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86f2d12f7736d67dae5ca2d1a0acfb1a01c6f93fba476f9dc7ce7a1b5aff883b"
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
