class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.3.3.tar.gz"
  sha256 "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1"
  license "Zlib"
  revision 1
  compatibility_version 1
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "00816346b3d80b3c1eb4cfe4244b1f386c8f6673e353d1371cb96f63bf10d950"
    sha256 cellar: :any, arm64_sequoia: "73a98dbbff35ba8f880438081be740da8131b0e3bbfa41f01e0072d140f4a9e7"
    sha256 cellar: :any, arm64_sonoma:  "0e134ebdd852a4a7001e4f6e3b64dc236bef23784b7cc358a876d291fb3f4672"
    sha256 cellar: :any, arm64_linux:   "e5fb75f8592d741139b0490622f5d2b232cfefeb79397b3158aba630258da6a4"
    sha256 cellar: :any, x86_64_linux:  "b8d7e8802092be9ecc516a0a43f35da61f3a83c73ba2e65b55419195a7ce7718"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  depends_on "cmake" => :build

  link_overwrite "include/zconf.h", "include/zlib.h", "lib/libz.*", "lib/pkgconfig/zlib.pc"

  # Uses a test resource
  allow_network_access! :test

  def install
    ENV.runtime_cpu_detection
    args = %w[
      -DZLIB_COMPAT=ON
      -DWITH_NEW_STRATEGIES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid rebuilds of dependents that hardcode this path.
    inreplace lib/"pkgconfig/zlib.pc", prefix, opt_prefix
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://raw.githubusercontent.com/madler/zlib/3f5d21e8f573a549ffc200e17dd95321db454aa1/examples/zpipe.c"
      mirror "http://zlib.net/zpipe.c"
      sha256 "e79717cefd20043fb78d730fd3b9d9cdf8f4642307fc001879dc82ddb468509f"
    end

    testpath.install resource("zpipe.c")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end
