class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.1.77.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.77.0.tar.gz"
  sha256 "cb98c0d15caa7c84da24995e8521f42f4e86a860b9748418154d8649b6a0db2d"
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
    sha256 cellar: :any,                 arm64_ventura:  "5dc881625cd83e2ddb7d7692c641ec347571ba38d0154f98b4bac9462f6a3731"
    sha256 cellar: :any,                 arm64_monterey: "32c08e8eb99def263e245d8f4a99586de5dc835f9a2543b4128d199623baf9a3"
    sha256 cellar: :any,                 ventura:        "6b7bc6506597f40e3445fc6f73e98756da04ebb708b703f40bc7d7d3da0c71a6"
    sha256 cellar: :any,                 monterey:       "fd0eafd41788d9f74570f7353129adf12eced702f37f9cd9095b48aebaf83742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc389fb619640d66c23b89d7da5ec311ddb21b7d0ee602a00bbe3eb9601aa87"
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
