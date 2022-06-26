class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.2.tar.gz"
  sha256 "3b1bcb14ebda572b04b9bdf07574a449c84cb924905414e4d94e62837d22b628"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e8db729f069ebd07a19f506d28a3f491328e6d6521d81f3176617fcdfcba2b9"
    sha256 cellar: :any,                 arm64_big_sur:  "da78f2f142b179a51309a70d2a823960198086609fc6f38dfc45559b2e581e13"
    sha256 cellar: :any,                 monterey:       "b27445521d7cf59ccecbb3842fab8f6b89c54b98fb22eb8707ec68bc9f2926f8"
    sha256 cellar: :any,                 big_sur:        "1b530260c922cc08de98cad6dc62e124ed05efd190a79364809268cfe566e7a6"
    sha256 cellar: :any,                 catalina:       "ec45e12636b266303efe3ca1d4cb3cc595955c62ff197a900e6f0f0519bb51e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6916cca964b049c777c87efd01272c76a246349cd93306e57fc68a8edaae426b"
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
