class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.09.14.00.tar.gz"
  sha256 "ba64492b08cd569b4fb7db1d40856ae0e12c279de602840928efa9f4c9c2208a"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b7728ce3d40e3c281c55ca5bba308ac87ab6ab6fab593da805165b71e8594e29"
    sha256 cellar: :any, arm64_tahoe:       "3193c0aa1e93176b01ce8eb6f6956b0a0d7955a5241fd740b819ba4315b3dc53"
    sha256 cellar: :any, arm64_sequoia:     "32baaa0b589719698817ebbbb6d53b53b730beb0924f3d4284988371d50eaac4"
    sha256 cellar: :any, arm64_sonoma:      "40ac6b1ad9603e8379d532f3401f254903cc9d87c35bd2c5bca02fd31f0c068e"
    sha256 cellar: :any, sonoma:            "30862f5567aeb77466c0b999eb911d2b744aedd197c44fe47a4044a00d2f3b17"
    sha256 cellar: :any, arm64_linux:       "4e6b0edd966ed4b4f43a36c0b974e023f18dbf2b7659631debd577b1b26c6436"
    sha256 cellar: :any, x86_64_linux:      "28c27c5d1401058ae7214deeef3cfbf6c62acd890cd0ae19ddf2d6462cddcd6f"
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
    url "https://github.com/facebook/watchman/commit/21e10ae9596a81ac95795ee0915f4308a9c34603.patch?full_index=1"
    sha256 "be595623d5a520de9e1820f1388ebbdf3ef9ff5d665a33c0231fdba36b5d0dbb"
    type :unofficial
    resolves "https://github.com/facebook/watchman/pull/1348"
  end

  def install
    # Drop the `GlobPath` C++ type as its GPL-2.0 header is not mirrored to this repository
    # https://github.com/facebook/watchman/issues/1355
    inreplace "eden/fs/service/eden.thrift" do |s|
      s.gsub! 'cpp_include "eden/fs/utils/GlobPath.h"', ""
      s.gsub! '@cpp.Type{name = "::facebook::eden::GlobPath"}', ""
    end
    inreplace "watchman/watcher/eden.cpp", "std::move(name).intoFbString()", "std::move(name)"

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{python3}
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
