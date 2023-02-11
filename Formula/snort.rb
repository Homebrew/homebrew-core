class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.55.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.55.0.tar.gz"
  sha256 "61cc080943a37b1c9ce1f398958ec0415181a31390dc165ebbf32d9af7b3dfa6"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cc9ae99099c5949fa2e764267f635f7482386ba6a788528b50ba8140b16cd9ee"
    sha256 cellar: :any, arm64_monterey: "9e6b4aeb49804e672ff0c3bdfe264d5ff4f20baaac24470074458bbbbf79762c"
    sha256 cellar: :any, arm64_big_sur:  "f2cb423e237525fc58cd22279bd1cdcfeb1479f6e1e62858d83f700d609bb572"
    sha256 cellar: :any, ventura:        "90be55b30f3ea2cdff3856470ed4116402a387301c2020f333387f46a863de5a"
    sha256 cellar: :any, monterey:       "d985b0984e483952d4cf9e06b66a0bf31209f693b68ccb783e0384088589260c"
    sha256 cellar: :any, big_sur:        "46fe6ef734f0795940ff3af319018795227dfbf28bdcbf659799155bef38a21f"
    sha256               x86_64_linux:   "6677fcd8a9748be5cdf45404db1ab6fce4d5d40f136a615c76ca52da6bfa382f"
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

  # build patch, remove when it is available
  # upstream PR ref, https://github.com/snort3/snort3/pull/286
  patch do
    url "https://github.com/snort3/snort3/commit/2b498993a47c728c3e273b440266eb40e5aa56c6.patch?full_index=1"
    sha256 "fb93fe6bf01f3f7d3479c25f2ebe52f0d19b42574b608ec15451c3397906139b"
  end

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
