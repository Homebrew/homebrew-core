class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.12.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.12.1.0.tar.gz"
  sha256 "257410621c4b726f1e01b4a00d9d094d4570d8bbfe060143c7195db7530f8887"
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
    sha256 cellar: :any,                 arm64_tahoe:   "512056c62eec84f0cc03104f69dfd13d62e4776d01df8866ea578365b3b4b1d3"
    sha256 cellar: :any,                 arm64_sequoia: "564b066419330535b1b81b30a3c6500c91aab2d9f5401ce502c2669e308e3627"
    sha256 cellar: :any,                 arm64_sonoma:  "eb7313f78f69f8b1feb24cc2ba8c52486052fbf12ba8ad97a36741560ea1847d"
    sha256 cellar: :any,                 sonoma:        "6a67590b6c212f9cff493745d19e546e4076b14d72d05a5ea2019e100cc93b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee91e70a94b4cbc85a392137e8158147f5fe9b3739b735c40adadc96b9bd82a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dafc62606bdb5d765ee10bee9d780ef83a0f8367229084a4c275ca7c3b920ac"
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

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
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
