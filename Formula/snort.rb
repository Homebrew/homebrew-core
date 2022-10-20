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
    sha256 cellar: :any,                 arm64_monterey: "80a9a4cb119ea06f96a210c2e4ab987b0b5836f859ed21a5eea0ccaf0cbf8b14"
    sha256 cellar: :any,                 arm64_big_sur:  "d084c76333716d9efc81495a59a790277553e32c45d98b85a0dddbddd7270868"
    sha256 cellar: :any,                 monterey:       "ca8f6252993ce7ed19adeddab2a1b1be310993030f03e2cc24ba27aab180a739"
    sha256 cellar: :any,                 big_sur:        "2e871364434209ed691db574fe2d1303cc288ad8db07425334ceab5e3c7a34c5"
    sha256 cellar: :any,                 catalina:       "5c16d7c869870e84ba601b15a3fefd801eb471d306bebb1baf1df0858f22e441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bbe3da7059276d0b41ec92d78875856a0f546054f8b401d9cd54d1175dd6aa4"
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
