class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  stable do
    url "https://github.com/facebook/watchman/archive/refs/tags/v2025.04.07.00.tar.gz"
    sha256 "792ded3402b74d62c45b2ae5ff91eefe0472ce1937cf5067b019f90b9e6a67d3"

    # Backport commit to fix build on Linux
    patch do
      url "https://github.com/facebook/watchman/commit/3d91e6db2f1e0cded7abdf10cf3bfc0a13c4f61f.patch?full_index=1"
      sha256 "723a80ca790afbd942689e854abd0428438750171622f4c9a69ac65e2ac8e6e4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6998f7af83ede3e531a2ec4857274e85ec61324bbbe8b32df1125aad21642055"
    sha256 cellar: :any,                 arm64_sonoma:  "32d3c99d143094bdf85ab7b7f6bb6df75c2b298dff33bf75d4cf93ccc5ac99ef"
    sha256 cellar: :any,                 arm64_ventura: "d15964c61e89ff8ecdb19786a063c27dfdd870dd34b4812e752df34dbb8acb8a"
    sha256 cellar: :any,                 sonoma:        "479c7c1d72cc04fd3c8c10d0a5f1680fe82af868e542f2982f84e60978816e06"
    sha256 cellar: :any,                 ventura:       "ffde44973082c0da06b0e996d32f19e154718a773a947ceb6306849de855ddd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcfcc5e147e0783898c23c08030276add893cdc91261f7f75662fd56dbcffee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36645a9544a15bc30febe73ae9be36250d9371581b2190bfe3dd6137acc6570c"
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
