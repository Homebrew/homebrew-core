class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20210324.tar.gz"
  sha256 "332dce11a707c03045dd3c3faea4daf8b9d5debb8ac122aea8257f6bd2cf4404"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "855e3ee08cbf5f3faf38ce9882a50726206ae937b5aaea7e05a0428ebd5a3a98"
    sha256 cellar: :any,                 big_sur:       "09a4f52a2be595e32ca3fc36a34382c99b81b3dcd100100c2044f7a062fa26f8"
    sha256 cellar: :any,                 catalina:      "c33b1518d8c66b25952e32d0b52ce8e44b060818056e0d09f5a594bd349fef52"
    sha256 cellar: :any,                 mojave:        "0ad15790baa3e9045a7d82ecf4a8e40c35f50006c50bd6229ca8b4485ca35071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3495fd46b0aa2ad9a540d8143f3d0c4b022f3df80e1874016e4edff219099e29"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
