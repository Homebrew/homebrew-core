class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.1.0.tar.gz"
  sha256 "e1a4439ee23f4557d7563a88c67044d50c384641cf160d95114480404c547085"
  license "LGPL-3.0-or-later"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c06ddd5fb3a97f373bf5a62a87410fe28e94082aa71c9cf5501da932faf94f73"
    sha256 cellar: :any,                 arm64_monterey: "304cf14a65977bdf52fd553dc7c9b9ecdad0e34dcf7ba3d26d4d415154439001"
    sha256 cellar: :any,                 arm64_big_sur:  "6bb8a167fd979ed2d95b77d2fa5802454c42fce025070bd262925425f41fc6fa"
    sha256 cellar: :any,                 ventura:        "812b26637fd328e6ddffc2449e32f23b568f571cad88c44bbe2df1308ebe1ddc"
    sha256 cellar: :any,                 monterey:       "86f04b64fd3ef3984698c0587bb8944907856d876fb9b2855b4564dc3efd84d2"
    sha256 cellar: :any,                 big_sur:        "f724a20b8eb444be7c01ecf3467eb0b57d8896b9dcebb3a09926e98bbfb4fdd7"
    sha256 cellar: :any,                 catalina:       "0a92ea87867b322edda329832975bd269f4baf18319b4a256f36bf24f09ed19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb6ad40b5c2ec40cc9d3894ef3de12fa8cd3a612e22a6e58b58178e5792187fd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
