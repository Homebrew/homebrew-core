class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.1.tar.gz"
  sha256 "3cb580928fcd502426809c68406d04aaa5ef1af7ebb0a3a41a52a13576f2fc07"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "95ddf1095df23db2682455e7808705f71f54aeaffa2c40cd57427301d98b8d83"
    sha256 cellar: :any,                 big_sur:       "feeac7058038e22e2259587a6270521c78df2768b05f680e6a0cf5d7deb4d148"
    sha256 cellar: :any,                 catalina:      "5d26a336dd453c35e308c30404bcf1a563cb7ee3af3f3ea38500eeece25384b9"
    sha256 cellar: :any,                 mojave:        "93b0de78bbf5fc52aa8755ac908bd4cc97c6bab1bbe50e7a57c6e6e2f2a9801f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94a0bfed3b0241806884af7c50ab4432e1c042c5a14c2bab6f48ca21c4bc2b4"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "test"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
    libexec.install "test/rtpw"
  end

  test do
    system libexec/"rtpw", "-l"
  end
end
