class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.61.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.61.0.tar.gz"
  sha256 "207963ece2eddd3c85ad90c9e2dabe33dc67eaa485ba9576e2b244f7ac45fc5d"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7967a24f7881ebd00f79805db7c78319923cfd37eaa7c7e17ebccd0f81ea2ef3"
    sha256 cellar: :any, arm64_monterey: "fdb056e7b6c723e55dc1e887421714b0d59203472f72c6b99cab638e5768ad74"
    sha256 cellar: :any, arm64_big_sur:  "f4b162d6fa5d1ea595408e7f2877a48d06a205ec9f0ec6f1d41f5ab3ab5a71cb"
    sha256 cellar: :any, ventura:        "8eea1eb77ba33731f1481c2593d73125a593f41e3ab5f099e414eda37c58c4c0"
    sha256 cellar: :any, monterey:       "553010e9f68d21ab788353874ca84557c60fe16f85d74834e723f03ab7101a8a"
    sha256 cellar: :any, big_sur:        "2305efd0642b724b82ee09f1c0372f058be17fa38ce8a6592d860bd45cb0ce5e"
    sha256               x86_64_linux:   "dc08497b5fc7cfe180b8a209ed5dabcdfe5aa899b77638d6e905e76ff42488eb"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  on_arm do
    depends_on "vectorscan"
  end

  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
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
