class Uvg266 < Formula
  desc "Open-source VVC/H.266 encoder"
  homepage "https://github.com/ultravideo/uvg266"
  url "https://github.com/ultravideo/uvg266/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9d4decb1b9141ce7a439710a747db7ef0983fa647255972294879122642b8f2b"
  license "BSD-3-Clause"
  head "https://github.com/ultravideo/uvg266.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b406c6c8a57f0e5e9883a31e3ba10016dfc7f465c3261a7d13a0684296b1ca6f"
    sha256 cellar: :any,                 arm64_monterey: "43999f593cc1905dccf002af7b0f0ab0f096c190a07195a8ec04f525e9f168e5"
    sha256 cellar: :any,                 arm64_big_sur:  "bf7c6bd61db0cd68ea8ed6242b0c3bcaa840f796adb19b581f0461bbca933f07"
    sha256 cellar: :any,                 ventura:        "ad40e5f6b1eb49b7faa80b1127430585f45532386821bd0171e7a20f31f27ef5"
    sha256 cellar: :any,                 monterey:       "c460c32b2e429fad2aa60db5350a9c54628b1ed886c63d70bd57cd9d4e32f88b"
    sha256 cellar: :any,                 big_sur:        "8bde502606bc413040b7a9ce6df353c14abda0cf6dcc7aa826bab67f111d11da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66fcaf4564cd4a496d7b6b7aba9c58af8a5e236b03c72b3a2276125f9c10af5b"
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
