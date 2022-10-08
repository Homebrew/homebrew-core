class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.43.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.43.0.tar.gz"
  sha256 "6273cdce0714c4743042e5d9ea649f1cca933662458efb9ebff8cf29d87af159"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e26d017613692ead3f4d6323f442b19cbf458ba489aeb27a5d9072e0558329f6"
    sha256 cellar: :any,                 arm64_big_sur:  "c8104719313ed8ed257916cd32652d1fa900af547688f76819ba637f86644dd2"
    sha256 cellar: :any,                 monterey:       "28174f5311e54540967cb5275ef8915b58836703f369eb806a23dc9b5061f968"
    sha256 cellar: :any,                 big_sur:        "a1df5de4cbfa2d28da9c944b4894468cd76356fa3b0d64d87185be4599729e45"
    sha256 cellar: :any,                 catalina:       "1dd142522f4a082154a824f705615839971d4e485a8db8f8ecbab87c85067a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b111786528a44a70dc6a0287ddd36e01ddfebc9e54f651c02d3aee0277dd82ae"
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
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  on_intel do
    depends_on "hyperscan"
  end

  fails_with gcc: "5"

  # PR ref, https://github.com/snort3/snort3/pull/225
  patch do
    url "https://github.com/snort3/snort3/commit/704c9d2127377b74d1161f5d806afa8580bd29bf.patch?full_index=1"
    sha256 "4a96e428bd073590aafe40463de844069a0e6bbe07ada5c63ce1746a662ac7bd"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
      system "make", "install"
    end
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
