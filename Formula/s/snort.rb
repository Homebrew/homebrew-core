class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.3.7.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.3.7.0.tar.gz"
  sha256 "ce4c5fc162ea3245dbd5aaa7661843731b63260d78b9ba7b9a39cc62356e1cbd"
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
    sha256 cellar: :any,                 arm64_sequoia: "8a2ddf9c6749369a7abe50fde6a0bea783a006f0f43886d5e79521dd32cd466e"
    sha256 cellar: :any,                 arm64_sonoma:  "36b28d566b076791a1ae1fdfa77d55af9c5eca25bdcf1d917034b53ffe072ecd"
    sha256 cellar: :any,                 arm64_ventura: "009ce9c64c35f3ecaca199af935ff77b6dd1d9b37bada6ed49a67887fae703f8"
    sha256 cellar: :any,                 sonoma:        "985af8106f5ba73a37b5bd3db11a7fdde2e43eba37b9b5be6c5398ad1ed51923"
    sha256 cellar: :any,                 ventura:       "18a04b6ea83b66177e4bdad379ffee3c25802d430f235922fc1c3ce623d00881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2256862c046c214663409da634aa40dc0e9590d53632002d511039ab6c5d4441"
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
