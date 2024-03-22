class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
      tag:      "v5.0",
      revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  revision 1
  head "https://github.com/avast/retdec.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6a14274c63866419820218f69a6e36fe17d9dbc3986a36650e5e95caf54ec2b1"
    sha256 cellar: :any,                 arm64_ventura:  "a5abd589cfd3394603c6add4e4f366376b70524c8aa052a402a661914a943e4e"
    sha256 cellar: :any,                 arm64_monterey: "dca8e0ebc65fe1055e006e72c9136e084bc7340020bff9caf411383ea802467e"
    sha256 cellar: :any,                 sonoma:         "8c080642f7e3b754ecf734c2d2e8dbcda730ded9cebf256b8b0fe34506b1880d"
    sha256 cellar: :any,                 ventura:        "ca1d84d78998a8bb2486739802da5ef48d5064ac89bf09123e097fdb5ae9c403"
    sha256 cellar: :any,                 monterey:       "5049e79d0a05645ad65c00b76abccd8cdd50f1124af262f16e7e29abd6b4fde5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95537f564ebebe2513e2208cccff8b35c8bb6863864236f9236a4b1917d8736"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "python@3.12"

  on_macos do
    depends_on xcode: :build
    depends_on macos: :catalina
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Running phase: cleanup",
    shell_output("#{bin}/retdec-decompiler -o #{testpath}/a.c #{test_fixtures("mach/a.out")} 2>/dev/null")
  end
end
