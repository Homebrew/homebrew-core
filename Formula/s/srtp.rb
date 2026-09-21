class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "ef5569220749529d778013aae1178391d972570a2b4f7288dda22effa875b07c"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/cisco/libsrtp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3649654b411ae51017c7bec40da936c910bd5eea3498be0002775cd8654890bd"
    sha256 cellar: :any, arm64_tahoe:       "6f392a60b22b5699938c7a3d1622cc69cbc70c3f9e1d241f4e4d76c86b6eefbc"
    sha256 cellar: :any, arm64_sequoia:     "3c19e95950df9ef96eb6ca4d100ac7811bf6055b0a0ea41911138d016ff62de2"
    sha256 cellar: :any, arm64_linux:       "aeea299389b07bab9158c453a11cb00bd1fefa82156285e8b9f6345976e2d74e"
    sha256 cellar: :any, x86_64_linux:      "89882f2b0d9bc32098721fb2855719e9d217b8b33f1345215972c3da1412c141"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
