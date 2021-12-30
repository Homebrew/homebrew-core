class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.19.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.19.0.tar.gz"
  sha256 "60ee32f423fcef72500ffb8514c1ae44398fc48407de6ec12ca2572486d48dfb"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "972f0a3ff887f055050169e35b5d32b31a717300f91d70e0f39f51668d592c7c"
    sha256 cellar: :any,                 arm64_big_sur:  "d77a3d13da44e54317f12610dbdf4c9750d3302adc3d494d2fdcc4e0de300c9b"
    sha256 cellar: :any,                 monterey:       "8af4f3099ad5528080491555cedf31b0434b877fd4624cb9ec363dceec42de50"
    sha256 cellar: :any,                 big_sur:        "a5a969dc0473a98fef08a83b78cf5846bd9552fe947a70be2a1d9f049b10ef2d"
    sha256 cellar: :any,                 catalina:       "173da28ada2c4e1670ce1038deb6dc0ccc17031189ee5d503cfae73e23c2f743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b10da9988a743bb4ab2b390861c70c09ac1e4990d24445ae8891284a35bb97"
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
