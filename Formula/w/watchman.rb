class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2025.06.30.00.tar.gz"
  sha256 "0da2e2a2bacce34ee1b918a3f86f530c670fcb398a86fe5fdabe195cb1187c41"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "634e7177c78f1afebb93f249724b3d1a129982d36377868f15ad1f4a44d4a7c6"
    sha256 cellar: :any,                 arm64_sonoma:  "ba29775db2ea38137452752410f4fe270089c1badb8be2f00820cad4fca9e751"
    sha256 cellar: :any,                 arm64_ventura: "fce5d6cf0b2e4bba6c0ff1217da7322832560429113bb0acc5e0b3750fcb5546"
    sha256 cellar: :any,                 sonoma:        "429253da6e32d6a3f094ad490ec9c030edd1603adfa6463fad5c9aa3d29135d1"
    sha256 cellar: :any,                 ventura:       "2a14021c9bcd0a665479e0c78bc52605e7dcd3711481a9558db1cbde293b23af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de524655fa7f454cdbd7ea8322499766b69707fbd4b58d97ea3c8443206e1510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bba4628ba71fa7afc5a5606a0978aceeef2768643e37991ed062584129fb81ff"
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
