class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/lemire/streamvbyte"
  url "https://github.com/lemire/streamvbyte/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "4d102a119a537e6d5e097fe06371de6397a57d89677de7193f92d920bb639f94"
  license "Apache-2.0"
  head "https://github.com/lemire/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b921386d8c36986deeb4093152cb2d323ccb9e720d378cb377aea031a75d9034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b33a02437b0cf9ce4e89233536c1da6a376e7cf583ba346d54253e4448700b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "781e9ebdd522b4f504e9df9a91f00ec61e461f6ac7eca40ed8df474f1e3c0fca"
    sha256 cellar: :any_skip_relocation, ventura:        "96d4a567eb5a8dd22e71f8dd29102f6d278f14be471f1e15b77faf132f25a604"
    sha256 cellar: :any_skip_relocation, monterey:       "69fc9e5a40b6fa7f064d8accc27574c1721981b21822d9be3fa077c38bc44d9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d43f3102dd5cebad6c5b73d252fb54fb1945f51d86acb555606b1673e1ed4301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf94e5d2d34022c91f6a355badb3fa205289356d22522eed6d368011c9e8e9a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
