class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.5.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.5.1.0.tar.gz"
  sha256 "3b47fc08cefa67a26296065a918f0c0c551d6185ec5ecaad505a7874e886ef6b"
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
    sha256 cellar: :any,                 arm64_sequoia: "86b93368e0ca78d595b2b4b96d413cff81f99f835353b1f51ff7c5e750fa8acd"
    sha256 cellar: :any,                 arm64_sonoma:  "d681b1f291cb59ff57fd681507a7ccb4bc85e30b7b2a29abeae66ac17aa04d74"
    sha256 cellar: :any,                 arm64_ventura: "d5a63a6df30ca528c22db34fbcaa37d3a023df59eb263023218812f95d259022"
    sha256 cellar: :any,                 sonoma:        "eb9f4f8dd1d21823fefa398c5bf7e25e70af82a8624ab6ed759315036b344135"
    sha256 cellar: :any,                 ventura:       "bbfdfe851cb8cbffa11b769a87480bf637c7869b4b9bb33e9fb38aafd6d53396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8242a6d57d6e88e82e42adb891670ae2a92d26ceb556e99c36c58f1ec9782132"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/snort3/snort3/issues/254
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

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
