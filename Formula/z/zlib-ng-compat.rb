class ZlibNgCompat < Formula
  desc "Zlib replacement with optimizations for next generation systems"
  homepage "https://github.com/zlib-ng/zlib-ng"
  url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/2.2.5.tar.gz"
  sha256 "5b3b022489f3ced82384f06db1e13ba148cbce38c7941e424d6cb414416acd18"
  license "Zlib"
  head "https://github.com/zlib-ng/zlib-ng.git", branch: "develop"

  livecheck do
    formula "zlib-ng"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "da58c82380d51a5ac285132e8888610cc14476e95e6280445fd335ef4cbc572c"
    sha256 cellar: :any,                 arm64_sequoia: "de2b7d5bc1e09399d31f45e1fe5bcec8a7ec2f3981061cd6c8a123925f38dcf7"
    sha256 cellar: :any,                 arm64_sonoma:  "85aa982fe79a27defd05121af49c64166d89fb1e82ada3d9f2928e1d96121466"
    sha256 cellar: :any,                 sonoma:        "8ced5ab346a3717bef52de72772277eaf7592906345035fa63aaffaeecfe7e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3b8ff2996ea3df499d16c1438248eec572cc6da8ddd00b5aab359756fd1b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2a5ba2917c2e7e97ab4cb5e5a4f56139474ba441ca808ac30915bcfe7aea44"
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
