class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.13.2.0.tar.gz"
  sha256 "298367524a31f0d4725ef12b2b06265b4e76e6545f990ae3dc3b5e4c10f6e0ea"
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
    sha256 cellar: :any, arm64_golden_gate: "9441a8308463c20fca030126ee293a8a0f26ffe0429e338ce6881230e210d9b6"
    sha256 cellar: :any, arm64_tahoe:       "2777e608b55393fc849f89c984e531915d4c4711fbca3e514ab0d5249999ae7b"
    sha256 cellar: :any, arm64_sequoia:     "bb37500db1581246f882883c53c5edccbdebd0f7b1a4b2ac6d275ae31e81e29b"
    sha256 cellar: :any, arm64_linux:       "20e9bd3503aa2638a5948e89d9899d5469fb8713ab84d55b07dece4a957cc804"
    sha256 cellar: :any, x86_64_linux:      "030a3ffb9929d099e9145addbbfd2e3823c881ec999ee60764b9d64e0ef14de6"
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
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    args = ["-DENABLE_JEMALLOC=ON"]
    # macOS libunwind lacks `unw_strerror` used by new backtrace.cc
    args << "-DCMAKE_DISABLE_FIND_PACKAGE_Libunwind=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
