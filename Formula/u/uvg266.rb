class Uvg266 < Formula
  desc "Open-source VVC/H.266 encoder"
  homepage "https://github.com/ultravideo/uvg266"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/uvg266.git", branch: "master"

  stable do
    url "https://github.com/ultravideo/uvg266/archive/refs/tags/v0.8.0.tar.gz"
    sha256 "27e4306577fe646951bd3c12685c1527b41385bfcb95262233669fc7f44f21bd"

    # Fix attempts to build AVX2 code on arm64 - remove on next release
    patch do
      url "https://github.com/ultravideo/uvg266/commit/e5e32d67f43ba73db4a1a17aa975a070f15496be.patch?full_index=1"
      sha256 "2b2e0938eeab7ea9900ec2f40e09debdcd908e13fffb44f66556baa904edaeff"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b3f0dcbb7047b2982860c57b4b9d94da3b69ee513c6587be4dd95fbc223ab94f"
    sha256 cellar: :any,                 arm64_ventura:  "fe2dc71d9b62684ff83a8de3fbd7ba21e491670d24a825a4eb19f05ac4df3d21"
    sha256 cellar: :any,                 arm64_monterey: "96832bedf204b7315199fe2c73d915d8899b118c0fdeb7e7366444238dcad9c5"
    sha256 cellar: :any,                 sonoma:         "84b745699bddeeda3528c792573cbad0bee61197b6d54520bf64eaecc53fc1da"
    sha256 cellar: :any,                 ventura:        "a4903dd76bb6286cc20becf914f043649e8b7c3b3fd2029c966b1a7f4553a3e0"
    sha256 cellar: :any,                 monterey:       "84e5397eca32b986e135eebf2bd67bf6b80cda9388d6396437d8d12b575aad21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64fb73e4bdaece14458cdfd4c8c123c298a8ce3fcfb483f2c3dc2ba22902bb8"
  end

  depends_on "cmake" => :build

  resource "homebrew-videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    args = std_cmake_args + %W[-DCMAKE_INSTALL_RPATH=#{rpath}]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # download small sample and try to encode it
    resource("homebrew-videosample").stage do
      system bin/"uvg266", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.vvc"
      assert_predicate Pathname.pwd/"lm20.vvc", :exist?
    end
  end
end
