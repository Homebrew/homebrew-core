class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.10.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.10.0.tar.gz"
  sha256 "6bd1c2c243ff69f9222aee6fb5d48998c7e24acaa4d2349115af324f9810bb01"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git"

  bottle do
    sha256 cellar: :any, big_sur:  "20a02212522fd5b3e67928e7435c2118c96e858ddd30ae6c57c7e8dd764db49a"
    sha256 cellar: :any, catalina: "f3ecad817c5ef3b9a4821c3644045f3cefe61a231b2e0e38a0a827ce5b2990c3"
    sha256 cellar: :any, mojave:   "efc0a9d82cd81e417fea60516e7f6ffa62b7690825515bdf321c759d5268f1c0"
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
  depends_on "luajit-openresty"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "xz" # for lzma.h

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # These flags are not needed for LuaJIT 2.1 (Ref: https://luajit.org/install.html).
    # On Apple ARM, building with flags results in broken binaries and they need to be removed.
    inreplace "cmake/FindLuaJIT.cmake", " -pagezero_size 10000 -image_base 100000000\"", "\""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_STATIC_DAQ=OFF", "-DENABLE_TCMALLOC=ON"
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
