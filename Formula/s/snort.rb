class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.70.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.70.0.tar.gz"
  sha256 "4917f2631d033383ca553002f5688b61df507f5c809b9ba62abceca45a7554ad"
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
    sha256 cellar: :any,                 arm64_ventura:  "9c2842d0ee2c3f95be0370e26caa90e0e56273822b128391c073a0ab39799b92"
    sha256 cellar: :any,                 arm64_monterey: "60c6915f885bcdd2c6b85756eb3872ebef94350ec6ddc58fcc032d3b5f212213"
    sha256 cellar: :any,                 arm64_big_sur:  "d2f41586b504a421814b6abecc31e31874efcb0b1637488ba464bf7def028330"
    sha256 cellar: :any,                 ventura:        "24dfe1d0d3a1c5e26b208be88816ae75a934769e2eebc9396448b211558e25d0"
    sha256 cellar: :any,                 monterey:       "fc2f3dfd09e8430ff9691d05b2fec060fdde13e11076ab05f0a917c9de2aedf2"
    sha256 cellar: :any,                 big_sur:        "00287a93bf6b7f424f0d5439449489d54d2f38c26504364fc1d8658031452150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f984aae2eddcd2a5f3bdb4a61dd8b205703a993ae0e54a2638a0592e355121e1"
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
