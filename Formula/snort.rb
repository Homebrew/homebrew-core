class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.56.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.56.0.tar.gz"
  sha256 "b757705e1ee2a560b94791b3f474fe1c562c98049ebb0c807e8f612c7c38032d"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c7320d51a082558bd902cc3bca54cdf34aab4020faf0cdea508d1560cd57b086"
    sha256 cellar: :any, arm64_monterey: "0c57fc226a52024c77624cbb27f375d71c00b941db8e709dd7939ba29b039e00"
    sha256 cellar: :any, arm64_big_sur:  "9314cf28843e11f6d7f1c30abfbf6f888b60357c9e64965cb0075830f7beb7bb"
    sha256 cellar: :any, ventura:        "c607cdd2351cae4ef5bf56dd445a35e54049bd888f3631e458f0d3672d5b46af"
    sha256 cellar: :any, monterey:       "c3c0492f9b117a9e3af01664f12b71e24320fabacf85bb27167e9019bd40f0c1"
    sha256 cellar: :any, big_sur:        "cc90bc1a1da477db17e8aab7bbf1682c7c20f614a0783fb597f2cc6972e15f3e"
    sha256               x86_64_linux:   "8f9f1bb30325897133b7c8c4c6e9255644c02d7644591fb9b4b023a2730bc387"
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
