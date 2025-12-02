class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.3.1.tar.gz"
  sha256 "94cfa0a53a8265c813c8369d3963bf09ac6a357824ad1f93aee13486176e152e"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aacec3db46402a05f36cb3baf5389ba7c88296317d9c09a322aa9152e2189763"
    sha256 cellar: :any,                 arm64_sequoia: "38b1262ec77f91a7d909b108a7091457ddfeabb80579cd202b78dc160e7a858d"
    sha256 cellar: :any,                 arm64_sonoma:  "bec2f95869eb83d0104085e0cb37cc6ecb4141db2977fd541ed645459390ebd1"
    sha256 cellar: :any,                 sonoma:        "a3cde1275c5b508f04f8058798270f869177968aae26cf4eb07d9b81a8f2896d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc139c570a5b324884a7cd14de3bf0cc22da86f3b7b199e2121a2bd4de254949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b61dab602e0cf930e245b1eb2af29eb45e910eba8bd572699bdb45ae18b5843"
  end

  keg_only :shadowed_by_macos, "macOS provides zlib"

  depends_on "cmake" => :build

  on_linux do
    keg_only "it conflicts with zlib"
  end

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
    resource "homebrew-test_artifact" do
      url "https://zlib.net/zpipe.c"
      version "20051211"
      sha256 "68140a82582ede938159630bca0fb13a93b4bf1cb2e85b08943c26242cf8f3a6"
    end

    testpath.install resource("homebrew-test_artifact")
    system ENV.cc, "zpipe.c", "-I#{include}", lib/shared_library("libz"), "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text)
    assert_equal text, pipe_output("./zpipe -d", compressed)
  end
end
