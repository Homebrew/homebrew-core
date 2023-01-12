class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.50.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.50.0.tar.gz"
  sha256 "983497578587c5b1291994608fef70700d7f251461e79ac897751bba57cc56b5"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce25f5607ce3d7768f80a526f596fa15facab68de594111e3dd59080f58910f6"
    sha256 cellar: :any,                 arm64_monterey: "a9573939de64a7f85fec078e5ef4e6474e0df70754348881ffdb8254661af71d"
    sha256 cellar: :any,                 arm64_big_sur:  "772b816f224f2942cede0e657e72a6081946a193f14306fa8c399969de292c3c"
    sha256 cellar: :any,                 ventura:        "902b7556f4c971d41f7912f51cbffd94b73d4295b39728b8399ce9872cd98f44"
    sha256 cellar: :any,                 monterey:       "f4a474d068470dace598b5f9d63c010420b4cc4f48fff4a1dce516bf334c9fc4"
    sha256 cellar: :any,                 big_sur:        "2fa6ad2448606a80e7f3383762f39b5dbb542aa04d7e4abd3001d7975567faf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a682aaa1368b3367bee81f67d2e648e514aabb26395577e8343cb8e06f02e0a7"
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

  # PR ref, https://github.com/snort3/snort3/pull/225
  patch do
    url "https://github.com/snort3/snort3/commit/704c9d2127377b74d1161f5d806afa8580bd29bf.patch?full_index=1"
    sha256 "4a96e428bd073590aafe40463de844069a0e6bbe07ada5c63ce1746a662ac7bd"
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
