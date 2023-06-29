class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.64.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.64.0.tar.gz"
  sha256 "57be62557178526059ded86d0bebf8a57aa4a46db9390a48ae030b6e45f1dc61"
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
    sha256 cellar: :any,                 arm64_ventura:  "1e83271f7a7f9dca259a7aeabcf0922f4a30ddafa00cefa72c5b54c8fe0322a0"
    sha256 cellar: :any,                 arm64_monterey: "20bbc8366a8b998674ddf31125014faf9d81b4746e10a7de71f9d6f100016c3b"
    sha256 cellar: :any,                 arm64_big_sur:  "df040193115efcc2417f106810caef17409ea7bfafc890f5c9a836f6f4b58216"
    sha256 cellar: :any,                 ventura:        "89415bb9f1f2005a2b76f51150330a279097abcf86d954f0aac463929c10c837"
    sha256 cellar: :any,                 monterey:       "20a0535c00180e0fdb014e66a31be1888e5654f24f5f4aa4a4b87eed7e34cf8d"
    sha256 cellar: :any,                 big_sur:        "006d62aa0df32389608861119d405a50d3c4fc39cc26eb52da135eb7c5f75cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25b5a39bd31f05b32ce169906eb0108a52554a7005d32caad288a9a5725d971"
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
