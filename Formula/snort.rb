class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.20.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.20.0.tar.gz"
  sha256 "aac67bfe4800c10444aa8fdd3bbe1362d5100dbd85d5d12f03255eafe2ca9399"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b183b85505cd9fb6043242c1b27880d7d3a8d8efaeb51454a80769073dac088"
    sha256 cellar: :any,                 arm64_big_sur:  "a8da00d8b9256e17907cbb0dd4eb45e6d9667caaacd8c481cb493dd43f4c57d0"
    sha256 cellar: :any,                 monterey:       "2005d7a190cc42a86964834b77fbebac11a823121f05875338900add69f971ac"
    sha256 cellar: :any,                 big_sur:        "bc85438df6623f4c3c31dea6a0d12dbfa0ada38a8acfc4b9f99096bb5c141d19"
    sha256 cellar: :any,                 catalina:       "c97d5d612325c8f06c2d701642f4e7710fb91b13e647b41b307d254d913d4786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fb19194d79e160537f715497534c5ffc2cdea2da5f0a3bb0b37f35955bc98dc"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  depends_on "hyperscan" if Hardware::CPU.intel?
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
    depends_on "gcc"
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
