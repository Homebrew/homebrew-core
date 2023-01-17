class Retdec < Formula
  desc "Retargetable machine-code decompiler based on LLVM"
  homepage "https://github.com/avast/retdec"
  url "https://github.com/avast/retdec.git",
    tag:      "v5.0",
    revision: "53e55b4b26e9b843787f0e06d867441e32b1604e"
  license all_of: ["MIT", "Zlib"]
  head "https://github.com/avast/retdec.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3dfd7d0d0b66aac5a3c4a7f333a4b0f2f7851971a846f19cd6175c0c32e4ca73"
    sha256 cellar: :any,                 arm64_monterey: "c04a36cb28404cc815388c76c21ce50678170240b87224ed0f6888027994caf2"
    sha256 cellar: :any,                 arm64_big_sur:  "ec2d9890fd1f2b255ed7b50540c339eecda7a1b09af70abb2b6e449c64e564fc"
    sha256 cellar: :any,                 ventura:        "38a135db8ca3194bb24020d3caa398acdd2ec5356f453e29d2093acaa1cbb168"
    sha256 cellar: :any,                 monterey:       "d76440c1290e3d55236ddd72c64a6ab7b3649a8abd4c65b28a8b945ac447a003"
    sha256 cellar: :any,                 big_sur:        "da5e8a6e9023347d01d8e0d2c6c05c724fa9a3792bb09f5ca64fd86a4ecf9828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10652a633bb9e69b41f513e2b8440159a5c9d7a5407fc124ebca6497f6d23cdb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

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
