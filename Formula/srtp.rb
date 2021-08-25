class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.0.tar.gz"
  sha256 "713c5c1dc740707422307f39834c0b0fbb76769168d87e92c438a3cca8233d3d"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "406c99da58c7402c0eab7f98a07b3b6ec2989ec0705e953969810a5c5bd560fc"
    sha256 cellar: :any,                 big_sur:       "be0566d1d89b9d9ccf62eab28136db6ccc822f0982133efb656e3221a5366f79"
    sha256 cellar: :any,                 catalina:      "ff098e6709a973779536b3908fcc263f549cdb221c955bfc736c8b09ca96dc81"
    sha256 cellar: :any,                 mojave:        "caddbc3415ff272cc130b8aa796f7d07553de8a9f6f490a2fc6d60ae4ce3a975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d815739fbd0f968ebc7cdcb77330dc459d5d19c80058ec86631a2ed05314755d"
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
