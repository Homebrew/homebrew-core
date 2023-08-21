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
    sha256 cellar: :any,                 arm64_ventura:  "e976bb48ed3134c1b66577c8a16371f58c919fb2e19de6aac69f4fe05fb90b9c"
    sha256 cellar: :any,                 arm64_monterey: "2e10771a8c543677b24d9a8e7834f0e68bad87d5ce0c79fd8d81c7aec5c37907"
    sha256 cellar: :any,                 arm64_big_sur:  "c862bcb6fc9aca00707abe35c7e2fef22a51a9907fe0ed74b5ba70b72bed1412"
    sha256 cellar: :any,                 ventura:        "e781c8d105388cc40825b04848f2168c67b5bcf381aebc77914f3752c59846d2"
    sha256 cellar: :any,                 monterey:       "61e8941ee8c7658c36728bc6cbe7d8cc89c343b60541a5c914cd05a6f8d74d50"
    sha256 cellar: :any,                 big_sur:        "c9b06269e6cefdc03d0045db89b812bd59a653b146c4550124f1109fbceaf6d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e6808edcaf5f70d1d753dcd5f358e7714c153a310a336780cb8d919e12e70f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
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
