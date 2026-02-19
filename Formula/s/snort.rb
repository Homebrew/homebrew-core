class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.10.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.10.2.0.tar.gz"
  sha256 "5a7bad8c0c0c87ee12c74932c6cafbfb28c44abed4055a2862d222ff270a384e"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "4e7a5762332205de04c1ab435f7a425d464ed084dce0ce98572ee3764015eade"
    sha256 cellar: :any,                 arm64_sequoia: "26559b090fc7b578b290114f6b718760a8577285f8f05ad1a7b1da08a53cab44"
    sha256 cellar: :any,                 arm64_sonoma:  "0527a08b1d28cae435e1c9727c04702e7a4fcc81ea204b7720de4d551dbd62c6"
    sha256 cellar: :any,                 sonoma:        "1724476f05cea9b12516ddf55695c5291b5fe64b36b0e4d7365df386c138bfba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcdaf8978a1d11f7aa271bd783c70e932e092b7f34e4993a84d3929ae92287f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7edd050479ff302b7473237bd109a3804786b01c69845d00b69b037e0a0faa2c"
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
