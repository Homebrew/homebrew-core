class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "bf641aa654861be10570bfc137d1441283822418e9757dc71ebb69a6cf84ea6b"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "434b6f64c212cee50599b634ff07f3c9204bdf83514793b0e77a71ae1a5988c2"
    sha256 cellar: :any,                 arm64_sonoma:   "f4659edc90366755154d729abdc17c15cd3f0afd5db88a34e113570b123fb32f"
    sha256 cellar: :any,                 arm64_ventura:  "c3ce5d112378cb65da6076012f3e57071e449cec1624aed7cb643c6875325114"
    sha256 cellar: :any,                 arm64_monterey: "d5caefa466b896041eb0eeaf3da044b75d19e63361b3bee650ac7ab99dc79ae7"
    sha256 cellar: :any,                 sonoma:         "7b016d3673afb8f2a19a6b25117562eb7749732b67830e94c389a45f2313ad60"
    sha256 cellar: :any,                 ventura:        "6854e02c592b23a903e2005f32686c5c2fbeab8bb2b442b19837db2b9f63bb61"
    sha256 cellar: :any,                 monterey:       "96ec600ba0b44ae3989159641862b20da7149af4d345d60d8b968918038b14eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae0dbd9de36ab4ca28ded9160425af7fa9ab1928b5de1d94049866627b514b1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
