class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.1.78.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.78.0.tar.gz"
  sha256 "08a51223c22aa3196e6dc959d3b52df03da9a458877ff7e77fa9c4ee8eb8947c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "e1a93e9c9b4498e953c22baa2013a57e2a1a7b9443e5431c90d406449a4578e6"
    sha256 cellar: :any,                 arm64_ventura:  "123ccb2b87f35f4f2ec7bfdc6dc39d332685e6911c8bfe740658dca8c00e59ed"
    sha256 cellar: :any,                 arm64_monterey: "71de0eed6d0b78b5f4a567f50b441b853bbebbaec61bc5ef69c61c4dd2688c5f"
    sha256 cellar: :any,                 sonoma:         "e0b1d6cd943b9b2578d8659d3a0405e20d836dc131fbc5b4c73a19075a1945e1"
    sha256 cellar: :any,                 ventura:        "60637c527f0378e48403ee3bba87a559787d984fe2a37465bd5d237921e6f33a"
    sha256 cellar: :any,                 monterey:       "d7ed83bc7bb17bca0da9e1dafb5bd8b56123098f496881f0c9b6ad92bb77a60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63016aed5e21d25d2bd64807403c7b8404211f5127f8d9cac016c8477923b0a0"
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
