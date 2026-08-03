class Watchman < Formula
  include Language::Python::Shebang

  desc "Watch files and take action when they change"
  homepage "https://facebook.github.io/watchman/"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2026.08.03.00.tar.gz"
  sha256 "36ecc782f7dc056e79bd664b3f4c6d4fe08ca78041835df2f1c39ef2566461f6"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1689a76ce398fb91584084eabe24a59dbeb6ab64dd1018082e97c07c85bc788b"
    sha256 cellar: :any, arm64_sequoia: "afebd249978ca929297b3d75ddfb39764126197a5bf0f8e44c4e46a3d32ef0a0"
    sha256 cellar: :any, arm64_sonoma:  "6280d7b4959bec0a8c712b7a2793fac1bec0d662c7fd43b05d23f84331218093"
    sha256 cellar: :any, sonoma:        "fd30689a9a9b2cdb48880637e63d44f7544a0ae63df00066642e24186b096bee"
    sha256 cellar: :any, arm64_linux:   "1757f5cbc031bfca43b58b2a4825bcb46aa90d6e33969c0b85be2b9443763bdf"
    sha256 cellar: :any, x86_64_linux:  "a11c63f505ad931e6fb778fdcbb7c8d5fc59ba754957bf8bb41f5943663939d6"
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
    # fmt 12.2 no longer provides fmt::format via <fmt/core.h>
    # https://github.com/facebook/watchman/pull/1348
    inreplace Dir["watchman/**/*.{cpp,h}"], "<fmt/core.h>", "<fmt/format.h>", audit_result: false

    # The release tarball does not vendor eden/fs/utils/GlobPath.h that this type needs
    inreplace "eden/fs/service/eden.thrift" do |s|
      s.gsub! 'cpp_include "eden/fs/utils/GlobPath.h"', ""
      s.gsub! '@cpp.Type{name = "::facebook::eden::GlobPathList"}', ""
    end

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
