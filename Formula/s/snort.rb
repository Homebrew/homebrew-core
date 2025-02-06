class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.6.3.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.6.3.0.tar.gz"
  sha256 "23476247a7e785008f91bebc84342d7c38bf608ce6ebefc352f3b7d008563b5f"
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
    sha256 cellar: :any,                 arm64_sequoia: "1c50401ad07cddaf33e5ffa2ac4a1e61b1d326595ca9ffb0b0600e93d303d71d"
    sha256 cellar: :any,                 arm64_sonoma:  "530e6f22a3d864722915a31edd8fae9afaaf1bb89afab7074da30bb2cb02f6af"
    sha256 cellar: :any,                 arm64_ventura: "ef2b795fb2c68eb395c8e5ecf7c3e39c523d0ccf686f5cf134b0a1628db0146d"
    sha256 cellar: :any,                 sonoma:        "ee47c6ff859ecfda2d48f0f664b1403d7fc5b5333cb955b40964e94c35431982"
    sha256 cellar: :any,                 ventura:       "b315a2e34234ff8dee0f99a60d840b119fa33868a1774dac39e74e9477803f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01871c5f1edc402455f7218b432a275598640000ebf68cad08cc7f497fb572c0"
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
