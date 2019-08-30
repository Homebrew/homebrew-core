class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"

  bottle do
    cellar :any_skip_relocation
    sha256 "50777e72e0f35004b980a433631bebc7904c971bf509349d80537d788167f8d9" => :mojave
    sha256 "4a7624626d440f813a04b80d11d04f5529ebab4c2e2079587505abc1df01ad83" => :high_sierra
    sha256 "ad56ade520d138d05387117756a57cb9cc4c4ba1b3ca1c2adc7dec5c8d8b1cb8" => :sierra
    sha256 "9ea1e1799cc9496ee7e391e65b1c69e693ff95bb5479c6be28138fc0f9fb9d7c" => :el_capitan
    sha256 "2cfd35e4f9b2d28d9ba72a318d7ca48f5b6bed7c7a655a6b0437254bab268186" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl" # no OpenSSL 1.1 support

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
