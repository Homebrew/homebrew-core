class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.1.84.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.84.0.tar.gz"
  sha256 "dca1707a66f6ca56ddd526163b2d951cefdb168bddc162c791adc74c0d226c7f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "1362bbc412578ad9b9aa0deaba709a566eb9cbe269573b8ece7a7648d2f2d2e4"
    sha256 cellar: :any,                 arm64_ventura:  "ee3beb14e54b75a8fcb560ade39c0b45e8629d89537bea001f99f5d5f7382032"
    sha256 cellar: :any,                 arm64_monterey: "d0023e58b3f5a962504f225bf59ba80ec36b4be4a15201ad236f05ad36978969"
    sha256 cellar: :any,                 sonoma:         "abc45d14ab79959edeeb9276d627388c49a0d617cc6f4539ee3f60607271603b"
    sha256 cellar: :any,                 ventura:        "bbabb9774fba7027c72e664427d205437dd59256abf86bc901dbfa3289927d4e"
    sha256 cellar: :any,                 monterey:       "9d3e41e3db44aca0f33481f338459345afcb4130e8ac73021c9629dd6220e070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff296aa78f632fb4d17d68c7175ac09081fdf8c55bca288ea0db3f81e31528c8"
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
  depends_on "pcre" # PCRE2 issue: https://github.com/snort3/snort3/issues/254
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
    # Work around `std::ptr_fun` usage.
    # Issue ref: https://github.com/snort3/snort3/issues/347
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_BINDERS" if ENV.compiler == :clang

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
