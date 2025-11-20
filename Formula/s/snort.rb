class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/refs/tags/3.9.7.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.9.7.0.tar.gz"
  sha256 "83a611ef3e60ef3f97de08537f7070c50f6acb52eaff9db48f3a464b573ab22d"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a86808229a3973615ef31ae47b95ddadb2e489065f7074c6df14ba557f7adce3"
    sha256 cellar: :any,                 arm64_sequoia: "0f0d95c84c9e5554383fe515301443970c264fd22652e05ce60aef2ac2d0d986"
    sha256 cellar: :any,                 arm64_sonoma:  "3f1a4abf8026c325ac4ea443a3ca1c18ed7adb10127c3b5499433393a3d575d5"
    sha256 cellar: :any,                 sonoma:        "da45e3d455822fe755105c46ef11fafbe7f6e2e117ea2e0ee878331177812f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97401e5eca8f8dcfa2963590a85956a1d03a0a74536992fb298be081de91eeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b40b53405be9ac5f5f85aad486d6388d2949fce409181321278be6b0fa9060c"
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
