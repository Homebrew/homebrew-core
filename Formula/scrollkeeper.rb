class Scrollkeeper < Formula
  desc "Transitional package for scrollkeeper"
  homepage "https://scrollkeeper.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/scrollkeeper/scrollkeeper/0.3.14/scrollkeeper-0.3.14.tar.gz"
  sha256 "4a0bd3c3a2c5eca6caf2133a504036665485d3d729a16fc60e013e1b58e7ddad"
  revision 2

  bottle do
    sha256 "9bd348638b9e3492db3549c7ac0756975ca2c57303ec58685bb3e6694fff1dd1" => :catalina
    sha256 "0d7cbee6e25a46848d7c387ba07c4ee110ae2256953d2e5addd26f68e21c645d" => :mojave
    sha256 "efa4637b9d1b3942192dca6fb4602ef72ec6b285ba424c087d290c8feb5e2c5b" => :high_sierra
  end

  depends_on "docbook"
  depends_on "gettext"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

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
