class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.69.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.69.0.tar.gz"
  sha256 "97083cd33a6ba33bdaa133bf19138a3f6a24ce93b2a9e285dcbd89858534cb72"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "052aa77ddd27cda9a0a936331f1968e9a5e791617184c5b6981f41146dc7ffdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c34f3ba1ac4d9732c4c88a9bf4ab239db7eb92cf0e141768eac044ec7c8be919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2edd9ef52cb5ffab10e266b9bd95cacaac545a65b100522a84e92980c53e0ae"
    sha256 cellar: :any_skip_relocation, ventura:        "a960630a7fd1e139af77289efaa79fa3a3495280ed13a72c7203d3fe87ac2ed1"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e09ebcdf3da2dbe2db3c633e4a9afb543124000900229f4885448883457154"
    sha256 cellar: :any_skip_relocation, big_sur:        "be4ed95ad0c3196a0872fae7ad2aff65af9561aa71af08090d2e048dfff9659c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5990edf1ab9bcdb381a83d18ca1af47b777b4e6a0bf803efe5b5b79b9fd51163"
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
