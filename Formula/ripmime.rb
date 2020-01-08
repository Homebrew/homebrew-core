class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "https://pldaniels.com/ripmime/"
  url "https://pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz"
  sha256 "896115488a7b7cad3b80f2718695b0c7b7c89fc0d456b09125c37f5a5734406a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbdb33bd7b2a1c5a2073b6cbd0c3916caa99d5de809f4915e138f523cb752026" => :catalina
    sha256 "976c8c7c1374fce9c9b4493f7c144c0e78db68223e1e7b53adaabc0978795ef1" => :mojave
    sha256 "915cd6326fe857e0608d25c9b6e2f4fab06734df23d0ad938184c1b791981345" => :high_sierra
    sha256 "09a2b60d927bbc236998e29ea50969ce95ab4470d74cd7a40a54f9f4ec24252b" => :sierra
    sha256 "1151fa0bb8a10779979cec95c7039832eb81b7126f808ba9c89ccb73cf658814" => :el_capitan
    sha256 "6ef2fdabe468bc42be725020ef23cc924d1572c7446648e38dbd6de3f1399a38" => :yosemite
    sha256 "741b45ca155022fb6b540dd1cc0882f5f29330b6909e37fd5115e84705d9d6bb" => :mavericks
  end

  def install
    system "make", "LIBS=-liconv", "CFLAGS=#{ENV.cflags}"
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
