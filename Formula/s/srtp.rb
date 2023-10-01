class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v2.5.0.tar.gz"
  sha256 "8a43ef8e9ae2b665292591af62aa1a4ae41e468b6d98d8258f91478735da4e09"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/cisco/libsrtp.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ea548163859fca444f3c643b9dd1494f28b69c51c52e239e78667265ace4f1fd"
    sha256 cellar: :any,                 arm64_ventura:  "61764349ccd575995fd3a57b64dc01dedf492c5b68bc17e8b8226e3ca2f96d2a"
    sha256 cellar: :any,                 arm64_monterey: "c4c7bbe9147a421ff2fa25b20212102b3d714abbe388ddf28f7ede003aba67d3"
    sha256 cellar: :any,                 arm64_big_sur:  "968b9151d48402479dff561d838c218d61632d559678d1cb240814e9c99450ae"
    sha256 cellar: :any,                 sonoma:         "762ace3b1574737359e3e12ec5a5e5c0c60147f3fea9250540d2aaafde286e1e"
    sha256 cellar: :any,                 ventura:        "cbdd3341c2290cbebbd14aed97744c6202c2bfed400bfbda88ae7abc66c754c2"
    sha256 cellar: :any,                 monterey:       "51e703779b38bc59455cd6f47e54f6a8bbcd9884f9e00671cd5a28696981cda7"
    sha256 cellar: :any,                 big_sur:        "b02f6996d47db4e07d3063dc444863cf01b921e4034431f7ddcc66bb9d33a75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a183bda0f672698897b793f85a2267e742784e0362f2e4cfc27c0d2a52c5e2e"
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
