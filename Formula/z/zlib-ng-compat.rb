class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.3.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.3.3.tar.gz"
  sha256 "f9c65aa9c852eb8255b636fd9f07ce1c406f061ec19a2e7d508b318ca0c907d1"
  license "Zlib"
  revision 1
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b54f4ab67f4956e7d0ede376704746985e5e8cfaa97ec299b311c74eb49708a6"
    sha256 cellar: :any,                 arm64_sequoia: "cf654aacfa54b53a5d1d3fbb73e3053fe43349253de8515f05b7070b430ba4ae"
    sha256 cellar: :any,                 arm64_sonoma:  "b61f5de1a8bff94d6161b1289e6d4b093842cdce1b6cfdeb768f48ddd4c4dc78"
    sha256 cellar: :any,                 sonoma:        "e449db4f2bd6dfa5bf1931f053ed2be4406a04408754e300323a8de68156a2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb6df814b35273cecd7caf4291ee1a972ab1ac20d11a126b0e2db556dfc50d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb72c27ca6918fb29af89b1287471e381e15156212ccd0e99661ee393bde872d"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  depends_on "cmake" => :build

  link_overwrite "include/zconf.h", "include/zlib.h", "lib/libz.*", "lib/pkgconfig/zlib.pc"

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
