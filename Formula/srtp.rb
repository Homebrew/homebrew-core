class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.4.2.tar.gz"
  sha256 "3b1bcb14ebda572b04b9bdf07574a449c84cb924905414e4d94e62837d22b628"
  license "BSD-3-Clause"
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7150a4fe5c5a5b5e93a8345d9b64376973e0893dfce37ae132421487d7f9277c"
    sha256 cellar: :any,                 arm64_big_sur:  "3ebd7be1e003bbf9ec2e1c28472e64267dc24c7ca70b293be4453e612ddce665"
    sha256 cellar: :any,                 monterey:       "5a05ef714a8ba7e266f133d8614d050f9effdbc289ee1af61972f4be5593e7a0"
    sha256 cellar: :any,                 big_sur:        "404fd8c6f3f32488086abd47324589e572cca109b9eacff92a1aa05d38178c30"
    sha256 cellar: :any,                 catalina:       "d968a110acc5db4c0090834cd7716b64d932e257226cf11b9e2efafbed263f84"
    sha256 cellar: :any,                 mojave:         "69a1d9cc8a5781881845db839adba2a1936c19d771a4527e4ba754571454f226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592cdd4d0cb837dea4f7b1e05989d316f113f75a95ef7e7198416b7e225f8241"
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
