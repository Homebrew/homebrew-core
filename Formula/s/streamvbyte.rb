class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/fast-pack/streamvbyte"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "51ca1c3b02648ea4b965d65b0e586891981f2e8184b056520e38ad70bcc43dd8"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b3c81835da9ae317838f2d8ad1a088c99fbdb465eccd4d338c6dade886c7cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "955cfd051b2957a90b5dcd3206023547acbc96298938bd489f7413eb2bc1721a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d9a35f2a353d5ceb107471e0467e5689a3050715513cae8cdf2cca75c30e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08b01a057acf0496f9e2afe325fcc1b051c812258a1026441a9b6705da57f2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "78259a695625fe8a4d8db9cce7fe270e9da2feb5f138af8891d553003abe6074"
    sha256 cellar: :any_skip_relocation, ventura:       "505180ca0088a187f5369cd4b4c9cc00069adcad065cfa04d976ef8a83da3a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333f773e6f4ccd9231d9802d1768d652c417a532fff56cfe398f0b0b2d291fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2086e097ff025f7f27bf7c1326f2493eed90785881afae43779a37c88b45fd8"
  end

  depends_on "cmake" => :build

  def install
    odie "Remove `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`" if build.stable? && version > "2.0.0"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
