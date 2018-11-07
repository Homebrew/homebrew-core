class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/v0.18.tar.gz"
  sha256 "b74aeea0526b606d0c0a8dfe4149670f7d34be9d4369e974a15abc67509a02ac"
  head "https://github.com/kilobyte/termrec.git"

  bottle do
    cellar :any
    sha256 "6d0ab2d3220afc8cd130d0f5c050e859cfdec851506653e232c74003fbd072ab" => :mojave
    sha256 "982701325a6da9d921d4a092269ec22c28363898e068ff6aa59df74d7b49198e" => :high_sierra
    sha256 "945043d319c728bfb239514c13407816dce87c1ad2f6b2b4cd8590d9d5c7dc86" => :sierra
    sha256 "787ed19e10d093b52b4aab2e6962480ea26b02ebda78bffb54258ce585c31ce1" => :el_capitan
    sha256 "53f6c1350027212566b1bcd5bb632a5cc5a9fbd56954b619a9bc0a96dd587bb4" => :yosemite
    sha256 "ffcb4996ef7e88fe41fef79289a65aa9d797e8ad10b7cc382fabc479d504bc31" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/termrec", "--help"
  end
end
