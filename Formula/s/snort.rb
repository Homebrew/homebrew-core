class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.9.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.1.0.tar.gz"
  sha256 "fc19f20cd34192eb78f28d7f128c79c5d0096733277f2b630a8cf892b10f33ce"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c016e1017793b07d107a9b28f71d8a20791aa9c1f930a96e5cf824ac95cc3e2"
    sha256 cellar: :any,                 arm64_sonoma:  "d686df7a4800d39408b91e40db14fc808f960b42cda0d7f6429d3c2c44060685"
    sha256 cellar: :any,                 arm64_ventura: "8820d52c31b127bb7ce2ad13fe70d33cdf37bfb9287c9a3866764aa79649ff52"
    sha256 cellar: :any,                 sonoma:        "84a960bd9626d8912d48280ae7281a5b627e0d3ec6747481f65cca988a833f88"
    sha256 cellar: :any,                 ventura:       "8c222c44f185f9d39faf0d98ca8a2d60425baf4d61b7d95275e71d02dcd9eaad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b7f4c2e14f236a6e144e1eecf96b4ba26d126668c1dc5974abc57704a6bfa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727ef2556b40c0789789686aeb306ed81ee10effe13865f3244d8954cf0e7fa8"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkgconf" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      For snort to be functional, you need to update the permissions for /dev/bpf*
      so that they can be read by non-root users.  This can be done manually using:
          sudo chmod o+r /dev/bpf*
      or you could create a startup item to do this for you.
    EOS
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/snort -V")
  end
end
