class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zlib-ng-2.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zlib-ng-2.3.2.tar.gz"
  sha256 "6a0561b50b8f5f6434a6a9e667a67026f2b2064a1ffa959c6b2dae320161c2a8"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbd2413a1db5b7bf43173f56725888855c386f5962e09a3201703749200ccb94"
    sha256 cellar: :any,                 arm64_sequoia: "b80ea1d2d7872c63508587b9287937383e8e63dbc2b41dade567959101c8346e"
    sha256 cellar: :any,                 arm64_sonoma:  "5a51f5527fe50e5116dd07a8e6c3f5a04966bdee14651d03f8bf8272a61051e5"
    sha256 cellar: :any,                 sonoma:        "551ef75024022cc811df70b832831db2be57bfd25ad394b1d9e979ad994057d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c87bb51d56eb46e83dc2f2e7b607ec178b1d032a9a228a83c1fdf8c670aa3d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cd052934fead732f6084ff17507850c65447842f8b96467c4f0bf114e4e2b0"
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
