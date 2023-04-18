class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.5.0.tar.gz"
  sha256 "8a43ef8e9ae2b665292591af62aa1a4ae41e468b6d98d8258f91478735da4e09"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97eebf4cbf6e97b3b6fee6fe7b9045115e8be848a012eee0683cff1636d1be56"
    sha256 cellar: :any,                 arm64_monterey: "03914b23b580b21e3c1b06a5861b9b8e234777d6744dcc06efd6883ebdf6ead2"
    sha256 cellar: :any,                 arm64_big_sur:  "4a42d3e420e366896f1b161ecbe720a540caa8cc19446db822d9b6e20a5cc388"
    sha256 cellar: :any,                 ventura:        "08b22802e2738dc920776a393afd00438c1a8bc8df2629e7bfef6719e094d1e3"
    sha256 cellar: :any,                 monterey:       "5a5c00b34b72e13cba8d40db062b6687d7ccc5ca1b489939c722e1df5da135d5"
    sha256 cellar: :any,                 big_sur:        "cfea980beb58db6e052234fb37ffa25bdd61546e6e1c0299b58a60d4d5b9e257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65bf6f97247f71fa63b515602f32833d8a7d33bcf5aef426fb417d7f5fdf73e6"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}", "--enable-openssl"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
