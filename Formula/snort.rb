class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://github.com/snort3/snort3/archive/3.1.32.0.tar.gz"
  mirror "https://fossies.org/linux/misc/snort3-3.1.32.0.tar.gz"
  sha256 "b93f74c6ee249d68ef09d93af2f052d38d0026ec548980d58eeb5470c3a13590"
  license "GPL-2.0-only"
  head "https://github.com/snort3/snort3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be194db46bb60d02a85fefc39eddda44efe72cf97d912616d846851ca8166d91"
    sha256 cellar: :any,                 arm64_big_sur:  "8034287159b7e0a23728135e644c4c6a4fe2b847c8c6aa77433b6407d23cc7e1"
    sha256 cellar: :any,                 monterey:       "4a6c030630b25cd4734e75e6c1c421c1b122361300f0bff866296a9546272f6f"
    sha256 cellar: :any,                 big_sur:        "1161608d7126aae863172176cefd9dac3a526d9d1d28a8665fca84f82f7461da"
    sha256 cellar: :any,                 catalina:       "30b2cde2f0e69021c92c1abef316abdcf0248038d05e5aadc03f3cce696395b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f23e98d4ab1ff113f2b0f3aff1244afce3aa89555eb2f26bb19b8db0881b1cc7"
  end

  depends_on "cmake" => :build
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
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # PR ref, https://github.com/snort3/snort3/pull/225
  patch do
    url "https://github.com/snort3/snort3/commit/704c9d2127377b74d1161f5d806afa8580bd29bf.patch?full_index=1"
    sha256 "4a96e428bd073590aafe40463de844069a0e6bbe07ada5c63ce1746a662ac7bd"
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
