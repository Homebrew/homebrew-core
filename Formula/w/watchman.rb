class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.07.20.00.tar.gz"
  sha256 "57dd5c70bf25a19b9ac08756ead71bd33c0f42f0cce58b151f1d6982d6d1abb3"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "055831c76945c45600f492aba51465f9426ebac8a6eba70d03361efb6d2225ce"
    sha256 cellar: :any, arm64_sequoia: "6c54d7b8468e257c6d0fc6fa06641b8c8452bcce108a47c3fc96b29fedbf87e2"
    sha256 cellar: :any, arm64_sonoma:  "e81db773ae8b69c0a33c304e2c7511063a98b293dce392f242c9bd893f0f327d"
    sha256 cellar: :any, sonoma:        "1b3bd404f95bdb83d688392dbb1a188432e802dff2dff635798f589cd229c052"
    sha256 cellar: :any, arm64_linux:   "df56f4a3e46a3ce5edbfa1b8919d25ad970452212915692b4abf34d7184d4801"
    sha256 cellar: :any, x86_64_linux:  "0dd193200950f0038206c1276f3edd2e7cc962da324c6887af99cb625b956c6b"
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

  # fmt 12.2 dropped fmt::format from <fmt/core.h>; include <fmt/format.h> where used.
  patch do
    url "https://github.com/facebook/watchman/commit/7dbd77e849641ec756fee53a587da56d4502b4d1.patch?full_index=1"
    sha256 "5855728d86bca5c11d08195db93659da91a813ce7a5c0293366aafe08970364a"
    type :unofficial
    resolves "https://github.com/facebook/watchman/pull/1348"
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
