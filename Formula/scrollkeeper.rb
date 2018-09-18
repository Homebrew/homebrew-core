class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "https://scrollkeeper.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"
  revision 1

  bottle do
    sha256 "558b4f276e0be95dc032a6f8edc391a2910fc6d9ff82a1174de989b4392dd12d" => :mojave
    sha256 "1b52ea53b42082614d8663a847db551dd0a793ea4e8b22b2c89f35c020d5c932" => :high_sierra
    sha256 "d1722082c68c3a2910fafd049b8f469a91e29586798b1b7ffc6cdb5b4e1b8f2d" => :sierra
    sha256 "fe0171c12bd61b59032a0914fd2279ca91132a714993d2dddd0f2641d8cb8142" => :el_capitan
    sha256 "ca1090d4daf705fc9bddc18b303ed1bf511ebd1173bcb48b17f5e47daab74351" => :yosemite
    sha256 "7e302cb0c50b34bf47cceefa2c79a8b565b06e7d850ea07f10992598c2058773" => :mavericks
  end

  depends_on "docbook"
  depends_on "gettext"

  conflicts_with "rarian",
    :because => "scrollkeeper and rarian install the same binaries."

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make", "install"
  end
end
