class Zsign < Formula
  desc "Cross-platform codesigning tool for iOS apps"
  homepage "https://github.com/zhlynn/zsign"
  url "https://github.com/zhlynn/zsign/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "2ba8b61369c0a6dd370c04ca51f65ad2e8fe2b6a8fcbc82656f30e3be97a6e17"
  license "MIT"
  head "https://github.com/zhlynn/zsign.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "09f7baf0255ee39e1de47a40ca39fc23236db122bc185193396cff4ae7bf0d34"
    sha256 cellar: :any,                 arm64_sequoia: "556e995dd4bb9cb34e3298b57b80532df2a66dddd463a0103663321c8002451c"
    sha256 cellar: :any,                 arm64_sonoma:  "3af45bba03883fa344504e28ef33aace713aab7094fb8456433020ba0dc38ce0"
    sha256 cellar: :any,                 sonoma:        "bd765ff2ae77407dfe6c5df0e7fe8c033f470fc0ad5336fed6e493bc1eaf8c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bccc331f4e5ae3d6ba0ce25aa91479a2183a2001baa2f8f59dada466d1f0029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc5233ea8baa7fe7e52172652c98c3e1082a66c263716136127ad31d163f0e6"
  end

  depends_on "pkgconf" => :build
  depends_on "minizip"
  depends_on "openssl@3"

  def install
    build_dir = OS.mac? ? "build/macos" : "build/linux"
    # Makefile hardcodes CXX=g++
    args = ["-C", build_dir, "CXX=#{ENV.cxx}"]

    if OS.linux?
      # zsign messes up the zip include path on Linux
      args << "CXXFLAGS=-std=c++11 -O3 -Wno-unused-result -I#{Formula["minizip"].opt_include}/minizip"
    end

    system "make", *args
    bin.install "bin/zsign"
  end

  test do
    (testpath/"fake.ipa").write "not a real ipa"
    output = shell_output("#{bin}/zsign #{testpath}/fake.ipa 2>&1", 255)
    assert_match "Invalid mach-o file", output
  end
end
