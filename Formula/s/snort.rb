class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.8.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.8.1.0.tar.gz"
  sha256 "adbd958bd0f9b2c78997bfda5a36cbbc843f07a71712db0b56f085e2cd124164"
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
    sha256 cellar: :any,                 arm64_sequoia: "2dd991165e878d700c2823249ff3be58b9c6abe90eefc067c9bda428e2ffeb3a"
    sha256 cellar: :any,                 arm64_sonoma:  "42cbe571a256c8e023acf4a034bfa7578f3566801aeed0e4042231d1816d0f4e"
    sha256 cellar: :any,                 arm64_ventura: "1d56b358ac3c8e293bbde3a85650a41a201a9deddb9e1ef8c8d80dfbea73fcee"
    sha256 cellar: :any,                 sonoma:        "61734701f5a56e885e7855b6eef1458194ed482d1975c2e07b5d92f9768526f1"
    sha256 cellar: :any,                 ventura:       "9a3f01972ebe1612df5fd40317406c6546bb9d1698da751af2d8ebcf62c3d8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffdb083db5c29c72412e4827adcd152f6f30914967120d799bae12adc8ce497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a42df450be376ded2537be9ce402d09cc62de7ffd30b79c17aa9812fb547d9c"
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
