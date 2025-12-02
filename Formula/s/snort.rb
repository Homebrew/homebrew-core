class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.10.0.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.10.0.0.tar.gz"
  sha256 "fbd6619e612998330f8459486158a3ea571473218628d9011982aaf238e480e2"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4fb4b1c2607726513d9d0ed202c3a0a23d0d236141d1676ed4a6021606fbc9ac"
    sha256 cellar: :any,                 arm64_sequoia: "64dd5b9d69229c10ba034befce6ed483279b01d527365493ada3892907585498"
    sha256 cellar: :any,                 arm64_sonoma:  "6ae3223cb870e302a25bac2b1b904d630fef3cf50ca4ebeb8d7c45ecc2e8fd67"
    sha256 cellar: :any,                 sonoma:        "499562e2c285def293c0aececfa9de7babac25e8ab4f46d06f37cee4728d9980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be45db270eba7ccea6e7e5654408334f8a20f92df080109dce8672077f2d1c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a108b5b3da511f2844970fc4dacd316c041123f53cc019b0fb8698a505b69a"
  end

  depends_on "cmake" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkgconf" => :build
  depends_on "daq"
  depends_on "hwloc"
  depends_on "jemalloc"
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "vectorscan"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    # https://github.com/snort3/snort3/pull/370
    inreplace "src/actions/actions_module.h", "#include <vector>", "#include <vector>\n#include <array>"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_JEMALLOC=ON"
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
