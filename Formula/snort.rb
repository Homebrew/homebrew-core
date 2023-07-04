class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.65.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.65.0.tar.gz"
  sha256 "c798e34703e1e6710fa7eecc4684f2cac58e310f85ce5d5f832945a036e7f542"
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
    sha256 cellar: :any,                 arm64_ventura:  "d4257c2846421c84864d355f3476b258ba78f0e63b2b76cab7e6eb7be92bab68"
    sha256 cellar: :any,                 arm64_monterey: "42b5be6b2a7d4695e98dd4f4b471ebb67ddaf8b0e593ada62c7554d0eb7a65f7"
    sha256 cellar: :any,                 arm64_big_sur:  "1604bc50a1314e2e6d1459e377418a75a5f3b19b36975d9116e4c71004b04fca"
    sha256 cellar: :any,                 ventura:        "b232362dc6bccf9bda5479bae260113e09b29781fd571e51f094b8875db32c61"
    sha256 cellar: :any,                 monterey:       "538c9560818e32dd2e6fdc7ba0843faad291428dbede6b77b7662bda25afdbb8"
    sha256 cellar: :any,                 big_sur:        "a994c92b6782354581827882c75ee017168cc2173aca216bac1d0aef765b0549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "276cd019997215df50525d27a05ac839419acc6286af74d40281999c28d0f076"
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
