class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.10.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.10.1.0.tar.gz"
  sha256 "fca496990d37adaf1ba9d61b7a89388a1a78b3d59bdc5980bffb39c616e0584f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "9abbf5d21692ab159a44d6bdfe484dd661ec87116924be603f0d9ffbb6e6dd32"
    sha256 cellar: :any,                 arm64_sequoia: "96e08a9f1b30093d9c75fb3fe383e07706e9a8bfc9a57a68b693caf5d9216c2c"
    sha256 cellar: :any,                 arm64_sonoma:  "52fb8766ccadf343c4869fbb5f0bd7a6c56836d4795fd55ea7150e58fb350bf5"
    sha256 cellar: :any,                 sonoma:        "ea945086d6ff41a70d4dfcec9874bf66daf673d8d47bab24503e350f2a4bf875"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b80cddb02df03aa96338a9ec70a7d5d1381d23cf33567d049d71ace80a95402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3da5b37024260eb5e308f0a2645d195555b7302ccbb68b26c9b07a2bfe87df1"
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
