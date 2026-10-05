class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.10.05.00.tar.gz"
  sha256 "69a97a8945f5f9177b01bf3160d50b3c4d7cbcf062d62f2ef3a1f901580533cf"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b500995747db3ec00fa5a42abc86eeeb23f390b10985c3586b310473c7238ec7"
    sha256 cellar: :any, arm64_tahoe:       "3071ef32f548e3e4660fb56321ec60128198d32f4bad0b295711a7cf7ab71461"
    sha256 cellar: :any, arm64_sequoia:     "204e57f0db5cd24449bf766325afb89bfb0a09518d7a28a8cd6ea36be53a77fd"
    sha256 cellar: :any, arm64_linux:       "d41a779667df2f3561ef59e0417fdf1f1dc15d5f452790e25d12e3e362cb163f"
    sha256 cellar: :any, x86_64_linux:      "4d0f81e2543d4a28128318d669edc59a2ce2898e888b5d19e2637779353859b1"
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
      s.gsub! '@cpp.Adapter{name = "::facebook::eden::GlobPathAdapter"}', ""
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
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
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
