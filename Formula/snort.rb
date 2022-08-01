class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.36.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.36.0.tar.gz"
  sha256 "49b68d9b3d86b114a962a73a123972aa1614803d99f817cf3175c0ca1c188427"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b85e43d2913c2099bf61f6087cc6c2d43f52fe1d90b438c12cc42e81576e081"
    sha256 cellar: :any,                 arm64_big_sur:  "6255dad20d58f2546b8d14b95def79f75729ec7c78feb2193156f766fd34f6be"
    sha256 cellar: :any,                 monterey:       "298f12f999ca0d2de48429ace04d147af67885584f60c9f76fc1edcbc46b1096"
    sha256 cellar: :any,                 big_sur:        "f68e42f96390ef255c7751e428c7bff8e16e68d1baba019e53de32549ffa60ea"
    sha256 cellar: :any,                 catalina:       "a1e5cdd6f5d3d6da45536247b1c3e3d67b0b12e6c0e430f32ff60e2862808a0f"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit-openresty"
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
