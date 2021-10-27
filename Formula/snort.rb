class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.14.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.14.0.tar.gz"
  sha256 "b36b2cd155ac03502f92f2a46ac7e3e2987ac1bc197a2655b1ae8386875aa489"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b11ce9796b70a03c15836f53725d0268e7e350df62c2e7576b32e6f073077c68"
    sha256 cellar: :any,                 big_sur:       "5d7e0388ba4d7edc10bc02f5373e6e603aadef5eaa2d07f66579acfee9b2a89d"
    sha256 cellar: :any,                 catalina:      "54e95d2b7c3166e577a756ffc55444c6f637d16f35dbaf84736b89691b5b51cc"
    sha256 cellar: :any,                 mojave:        "02b15fdadab1c48fbd50f56b21b8be397f66c3beb110b3a60bee57c4cb7b7628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22587697d870d998a712ba3ae06d16c7277d6f785bff0afb4c8c66cab5f5304f"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "flex" => :build # need flex>=2.6.0
  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "gperftools" # for tcmalloc
  depends_on "hwloc"
  # Hyperscan improves IPS performance, but is only available for x86_64 arch.
  depends_on "hyperscan" if Hardware::CPU.intel?
  depends_on "libdnet"
  depends_on "libpcap" # macOS version segfaults
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_TCMALLOC=ON"
      system "make", "install"
    end
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
