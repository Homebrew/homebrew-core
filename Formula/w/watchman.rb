class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://meta.github.io/watchman/"
  url "https://github.com/meta/watchman/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "513a78c03fef7706eec77548c8f9d02f37215c5987e067bb4c462451b930fc9e"
  license "MIT"
  head "https://github.com/meta/watchman.git", branch: "main"

  bottle do
    manifest_sha256 "2b87d35fbb1a6d8629d38a000549e028ae93e691cd8168f5cd15f0f0d02287ee"
    sha256 cellar: :any, arm64_golden_gate: "bd43b5e86a7efd741f25710c2f0e2ed589af953b171842753cc77ec8b183d72f"
    sha256 cellar: :any, arm64_tahoe:       "e0ca3add011238b26978f2de2f9e23116677691193eff25f73cf366df9820ab8"
    sha256 cellar: :any, arm64_sequoia:     "8b0a11f6fd789b2049fd4f6a586c03d19380dcabc9905f17fe6989dc3a22c3d0"
    sha256 cellar: :any, arm64_linux:       "95b950a865d98093095e4d1413ce7c929c6a2bf8d20cbacb1c91efad437d7df8"
    sha256 cellar: :any, x86_64_linux:      "ca004712ce4da39bc9ae37edb660283a550440078e35c32e337018b8a145edde"
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
    depends_on "libunwind"
    depends_on "openssl@4"
  end

  def install
    # Match the F14 ABI in bottled Folly instead of compiling for the host CPU.
    if OS.linux? && Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV["HOMEBREW_OPTFLAGS"] = Hardware::CPU.optimization_flags.fetch(Hardware.oldest_cpu)
    end

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    build_user = tap&.user || "Homebrew"
    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{python3}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{build_user}
      -DWATCHMAN_USE_XDG_STATE_HOME=ON
      -DCMAKE_CXX_STANDARD=20
      -DOPENSSL_ROOT_DIR=#{openssl_prefix}
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
