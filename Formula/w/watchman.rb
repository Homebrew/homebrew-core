class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.10.26.00.tar.gz"
  sha256 "cb0ec3a700412f7ea83b4853783a51738cf7bfc3cbac30d324a14f603f83ce9d"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ef0c957263b2e2d664d38991ee292b32dbfea042a85f598a0a54177ce63ebd4"
    sha256 cellar: :any, arm64_tahoe:       "f2c120de222ac253fa195898b0151c6cf37cc4fb4a6215bd6e2d408f0202114b"
    sha256 cellar: :any, arm64_sequoia:     "bae5abd596ad8664ea0a097a1a0d748aca085549ebf824aa492641ba64351b2f"
    sha256 cellar: :any, arm64_linux:       "6b6f1b6e1893ab6bbb5f51596cf865bc1f76c8edba1f163edc645464c11ce035"
    sha256 cellar: :any, x86_64_linux:      "e7658729af91aea139a5e27312c4edf82bbd9b0635a9f22b48c1bc07977c5e08"
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
  depends_on "python@3.15"

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
    # Match the F14 ABI in bottled Folly instead of compiling for the host CPU.
    if OS.linux? && Hardware::CPU.intel? && Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}"
    end

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
