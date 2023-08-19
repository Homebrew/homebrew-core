class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.67.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.67.0.tar.gz"
  sha256 "fed8ea7cf00d69c10e5750a6507392730552594f4f4a0dd5d1bf259a691b9a54"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d18fcf36d299f8711f9a2c8842d2b33d6b0a7e7ac5619c21c4f2fad3002c07d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb5d61452b29bd2d613fb818173a50ff2cbcef217dfb2e5d7d650d393f3c3988"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f03c39b881180682a57467a192e2807a4dc9ee3ab82e4b85da99bc898f4aec"
    sha256 cellar: :any_skip_relocation, ventura:        "adaab06bbb802c0f628d14135a6d8150c0d046a5750fb202f6097006a57aa01b"
    sha256 cellar: :any_skip_relocation, monterey:       "37e3643e7542df9fd5e851cd5c913ab8de3600e80bf6d2947d5f0f9282aa8bdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "95e1cbe38b4688a01c9693f7badc8806fc62f3b723fe0359e0cf86f8d5c7ce96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04cfc7eeaf9e8b392861f857b6d07f234933ae7477e1c72f4e8a69e39862280b"
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
