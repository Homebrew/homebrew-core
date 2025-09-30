class Replxx < Formula
  desc "Readline and libedit replacement"
  homepage "https://github.com/AmokHuginnsson/replxx"
  url "https://github.com/AmokHuginnsson/replxx/archive/refs/tags/release-0.0.4.tar.gz"
  sha256 "a22988b2184e1d256e2d111b5749e16ffb1accbf757c7b248226d73c426844c4"
  license all_of: ["BSD-3-Clause", "Unicode-TOU"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f9776e783d8c4f8a9b2d570e3d713fab96a4d971e9299c433ce5f13693201a0"
    sha256 cellar: :any,                 arm64_sequoia: "e2ef892ce63fb20afa7af121db7e7291850badb448c4b0350ebfc6c5d7340051"
    sha256 cellar: :any,                 arm64_sonoma:  "ff95dde6a1e561d0d0389138643ba04db15fcddeb72c5770052ec05f196adeca"
    sha256 cellar: :any,                 arm64_ventura: "3ce57d5f033cec54cce82b5db47a5a4f8e17b28cd3ad4533c5b7686ccfb6c4b0"
    sha256 cellar: :any,                 sonoma:        "0fdd6b76bc801980b0ffe7f0d6d2054d9c29ce0a65fe6765cab150414b0ae7d4"
    sha256 cellar: :any,                 ventura:       "23f9392ae9330ecedd2ce2c816c40a56a4a159b751a679772a16ee8259f455f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44f5f6e6baf5168f5a86c4a2966114935de9e4c71b1d5a13676d1157b5fea3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3dda3e653e8248fcef21065c08ee18ca0e693544d48e733502ca8f594c2bfe0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cd "examples" do
      system ENV.cc, "-c", "util.c", "-o", "util.o"
      system ENV.cc, "c-api.c", "util.o", "-L#{lib}", "-I#{include}", "-lreplxx", "-lm", "-o", "test"

      # `test` executable is an interactive program so we use Open3 to interact with it
      Open3.popen3("./test") do |stdin, stdout, stderr, _|
        sleep 2
        assert_match "starting...", stdout.gets

        stdin.puts "hello"
        sleep 2

        assert_match "thanks for the input: hello", stdout.gets

        stdin.close # simulate Ctrl+D by closing stdin

        assert_empty stderr.read
      end
    end
  end
end
