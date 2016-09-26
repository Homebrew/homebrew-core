class Valabind < Formula
  desc "Vala bindings for radare, reverse engineering framework"
  homepage "http://radare.org/"
  url "http://www.radare.org/get/valabind-0.10.0.tar.gz"
  sha256 "35517455b4869138328513aa24518b46debca67cf969f227336af264b8811c19"
  revision 1

  head "https://github.com/radare/valabind.git"

  bottle do
    cellar :any
    sha256 "f5ab08ee268c72de90001029bd89e95c1f15dcdb4336e5b4e3629e952158b908" => :sierra
    sha256 "41b55e5323f21bf0c8482d1a38bf71c06e1cf27728f157fa4a918a1895d47749" => :el_capitan
    sha256 "758b949e314db82f2a1d66d22ff05628733a816913ad7baeaed44158e18372a0" => :yosemite
    sha256 "92a9c255be4f890f40db24b26e261c1df320cd74dbada405d2cd2fc2ac177078" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"valabind", "--help"
  end
end
