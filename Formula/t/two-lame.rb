class TwoLame < Formula
  desc "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "https://www.twolame.org/"
  url "https://downloads.sourceforge.net/project/twolame/twolame/0.4.0/twolame-0.4.0.tar.gz"
  sha256 "cc35424f6019a88c6f52570b63e1baf50f62963a3eac52a03a800bb070d7c87d"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3d0622b14c8204b38bc567923186649071882fca6ef5e8315d049958c07ca5ed"
    sha256 cellar: :any,                 arm64_sequoia:  "8adffc94879ee562f0f12517db906144dffb3e5154318eb23bd33426834f32dd"
    sha256 cellar: :any,                 arm64_sonoma:   "0a0ff83aa3691d3f363db88871bcc231cb139461f7cb5d1fd8bffa80d52a09b4"
    sha256 cellar: :any,                 arm64_ventura:  "7ea2224ac3c69dcbbc8a2bced6b9bd1b478effea5ded33806420e70e51f396dd"
    sha256 cellar: :any,                 arm64_monterey: "3b49ddbaac0612e42ffcfa8cda457d5602063d645f124da8c6353f15abc5c9c5"
    sha256 cellar: :any,                 arm64_big_sur:  "15f7868c873400af4b2f9e566356bfa00217f563d51511120367c4dc75d2867f"
    sha256 cellar: :any,                 sonoma:         "eba83a95de7443f34b27409f9bbb2d85311020f71f41d6611f430eafad9fa792"
    sha256 cellar: :any,                 ventura:        "5d52f911e18dfde2ae188d42b7f57033c4b246771da3faebd7b276962f6e88e4"
    sha256 cellar: :any,                 monterey:       "5f40da46c678cf30b76918f6ba6d38a80425fe52b6fd06c290608de175b3cfad"
    sha256 cellar: :any,                 big_sur:        "4847a0b0e48b6f8ac14113793e18a6b31d8dce22b09dc707c35306ec2b3ecdfa"
    sha256 cellar: :any,                 catalina:       "9ba9f3afb14f2ac2fa911046a83ee50ed6a93d747f0c305788a61b4138e5fe5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7878b98ffa5f6ca3ab73a54876e159bc42fa4bbfb9d73a5d7fa60af97d85812a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a0261525798a434c29f332eaa62ed01cf06c4bb2bdf76a64cdf2e6a46fd1b0a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "simplefrontend/.libs/stwolame"
  end

  test do
    system bin/"stwolame", test_fixtures("test.wav"), "test.mp2"
  end
end
