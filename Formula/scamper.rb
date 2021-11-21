class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211026.tar.gz"
  sha256 "be75919a59d73227598260668b7ed75f6a710507310ca9827789b18cd7dda684"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "172a57d0927be1c8f7a2fc7f6f50e7b6ab964582c6b4becbbf55dc8bb7b9b15e"
    sha256 cellar: :any,                 arm64_big_sur:  "855e3ee08cbf5f3faf38ce9882a50726206ae937b5aaea7e05a0428ebd5a3a98"
    sha256 cellar: :any,                 monterey:       "84a88c7b1f30397f915bb08ad216e80c5f128c4a771a7393dd0197c6f9aace74"
    sha256 cellar: :any,                 big_sur:        "09a4f52a2be595e32ca3fc36a34382c99b81b3dcd100100c2044f7a062fa26f8"
    sha256 cellar: :any,                 catalina:       "c33b1518d8c66b25952e32d0b52ce8e44b060818056e0d09f5a594bd349fef52"
    sha256 cellar: :any,                 mojave:         "0ad15790baa3e9045a7d82ecf4a8e40c35f50006c50bd6229ca8b4485ca35071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3495fd46b0aa2ad9a540d8143f3d0c4b022f3df80e1874016e4edff219099e29"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
