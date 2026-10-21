class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "ef5569220749529d778013aae1178391d972570a2b4f7288dda22effa875b07c"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/cisco/libsrtp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5a490871797cd5365e57a7f4717a5045d4131566746acb89b70475494c961e0"
    sha256 cellar: :any, arm64_tahoe:       "6fee7517c6f9311d72dc993c4f95994680159abdf469c4efaa8584bce449e951"
    sha256 cellar: :any, arm64_sequoia:     "544b884e67367bbe4e81cbf182995f08522a4c4971f6071ce9c696d018abd5e5"
    sha256 cellar: :any, arm64_linux:       "202bed5466d2ca7d0680cd56019088ef20f4c4a211fd18c98f5fc78886f73c1e"
    sha256 cellar: :any, x86_64_linux:      "3e0d054d4f65dead5a69281e2d956210c5f83d452bcb22259ba392c1380bf6a8"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  deny_network_access!

  def install
    system "./configure", "--enable-openssl", *std_configure_args
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
