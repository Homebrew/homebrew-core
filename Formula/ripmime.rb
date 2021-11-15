class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "https://pldaniels.com/ripmime/"
  url "https://pldaniels.com/ripmime/ripmime-1.4.0.10.tar.gz"
  sha256 "896115488a7b7cad3b80f2718695b0c7b7c89fc0d456b09125c37f5a5734406a"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?ripmime[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da00b953f185e99b41682ed5a122a6404f1fb7b3e814639011f66748b56d748e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb13e6706e28ff4a6fe8f976934c31baa1ab1d0709ec26ff9474ba38c3cea286"
    sha256 cellar: :any_skip_relocation, monterey:       "d87658f4fca98cfa99b8520fa6f2435e991d93c0cfb527f0dc031a2810475076"
    sha256 cellar: :any_skip_relocation, big_sur:        "151baef43758c5fa5166b3b6dba2d3340e8f117c5d2e67dc9ee86a366143ab54"
    sha256 cellar: :any_skip_relocation, catalina:       "bbdb33bd7b2a1c5a2073b6cbd0c3916caa99d5de809f4915e138f523cb752026"
    sha256 cellar: :any_skip_relocation, mojave:         "976c8c7c1374fce9c9b4493f7c144c0e78db68223e1e7b53adaabc0978795ef1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "915cd6326fe857e0608d25c9b6e2f4fab06734df23d0ad938184c1b791981345"
    sha256 cellar: :any_skip_relocation, sierra:         "09a2b60d927bbc236998e29ea50969ce95ab4470d74cd7a40a54f9f4ec24252b"
    sha256 cellar: :any_skip_relocation, el_capitan:     "1151fa0bb8a10779979cec95c7039832eb81b7126f808ba9c89ccb73cf658814"
    sha256 cellar: :any_skip_relocation, yosemite:       "6ef2fdabe468bc42be725020ef23cc924d1572c7446648e38dbd6de3f1399a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a34870dfc003b3d39cfaf0c27f85409fcc3579a5a53e2700f13bddc61be2a6e"
  end

  def install
    args = %W[
      CFLAGS=#{ENV.cflags}
    ]
    args << "LIBS=-liconv" if OS.mac?
    system "make", *args
    bin.install "ripmime"
    man1.install "ripmime.1"
  end
end
