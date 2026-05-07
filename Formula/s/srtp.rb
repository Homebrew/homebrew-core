class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d123dcff5c56d4f1a9006f2b311ea99a85016cbf3bb24b1007885d422237db85"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/cisco/libsrtp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3ed036f244dee0ef8186284cc93ea753f538fb38a18197bcb8fcd9e74fe5f44"
    sha256 cellar: :any,                 arm64_sequoia: "a7e0ff788ec0e9076fbb7902cb6b24a1854eceecb3b675e38eb99b116c20292a"
    sha256 cellar: :any,                 arm64_sonoma:  "63b06c8339037174cd50d8cedec99af5bdb75d780a517e7a59ebf867c1bbbd89"
    sha256 cellar: :any,                 sonoma:        "7d0d084800be5d755e7739303280a403601d87cf1e4d43b1ff61b5cda606e06c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a983dedc2fda9e9e8bf7e9f9ddeca24fc4a7433b449e2c83abceefc6336159f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59bb6e85932452bb147aaca56e4278c0565e8a9d6188de82bcd81456a42a138a"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

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
