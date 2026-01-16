class Wy60 < Formula
  desc "Wyse 60 compatible terminal emulator"
  homepage "https://code.google.com/archive/p/wy60/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/wy60/wy60-2.0.9.tar.gz"
  sha256 "f7379404f0baf38faba48af7b05f9e0df65266ab75071b2ca56195b63fc05ed0"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "27074202271ebad114a776e830498514e56da281471bdd05eed3d4eb00dbee09"
    sha256 arm64_sequoia:  "6e8b275623922f42137e8d90712e41890ac44f9218dc7ff8d8476068d7497f01"
    sha256 arm64_sonoma:   "e40096fbc12217c535cf856513e7a659c5e496f0a03ac1f3cbbc2c82782dbb5f"
    sha256 arm64_ventura:  "4416be14e5f87f206fd75dca1e15f6b2a1ec3a0fc2e1264c3d242c57dadf1217"
    sha256 arm64_monterey: "af9022e78bcd0a863d72bcc0c7ddeb5fa004318e7d3e39f17f630b0e6d3f25cc"
    sha256 arm64_big_sur:  "700b80eb03a92465ae6a0860bf3c3eb572c9bc97799eec577e2fcb694c050148"
    sha256 sonoma:         "fdfd9a3863cbb38a5d87eeeb04de4ccab9e503243848d7384173b47a7b7075cb"
    sha256 ventura:        "9274cf2e7bf58a7ae51ddc8d96634ad46c185bd177098b332069e5d8c3f545e0"
    sha256 monterey:       "8ca95f2514f7950df479ab89844c07038fdfed5b8b730a26a938be0e85bd4c41"
    sha256 big_sur:        "d9f755155083e888e0c001dc6590e88f90c5c1ae7868d7ec36865e127f60e066"
    sha256 catalina:       "29247a3617870bdb8364f9ce1b6d167b6029b016683dc5da39816b0a637bf5ef"
    sha256 arm64_linux:    "49410228b9210e6f2cfb22d8cf47ec007ce53b63ce2ad77980696efa5ea5f61f"
    sha256 x86_64_linux:   "a6e03720948c91ccddf6881bf9770a13ff9b1560b52e4ab007da15257c1bb3c1"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"wy60", "--version"
  end
end
