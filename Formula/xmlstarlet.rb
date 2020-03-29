class Xmlstarlet < Formula
  desc "XML command-line utilities"
  homepage "https://xmlstar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.6.1/xmlstarlet-1.6.1.tar.gz"
  sha256 "15d838c4f3375332fd95554619179b69e4ec91418a3a5296e7c631b7ed19e7ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a679570811f553e345748516fa37c2d4b529a75533bdb73316077aaed5ab8f6" => :catalina
    sha256 "6e5d11ee1419a61a9f043663c1236d064ee692fd187ae15bf2114b42d8f0889e" => :mojave
    sha256 "56ce0e3190080e6e1111ebb31aa06aea53f16cde50359a356c24ff86a4df72b3" => :high_sierra
    sha256 "4958bf868beefb9a2b391c0fe05f5289b67a4cded708d71c4cc5fced130bac55" => :sierra
    sha256 "2d9a9b5f875b91c78378e7f3df12595528d8e4b9ec9e321131b7f9f78f30acd8" => :el_capitan
    sha256 "525eafe6cab96cc6e04fef756e25316119b3c96cb61e5f7f51770cd062ad1bec" => :yosemite
    sha256 "7004b98b4dd9195a35f736ba3f6282369a2c63397a710056c5d1ae71d149fa3a" => :mavericks
  end

  uses_from_macos "libxslt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    bin.install_symlink "xml" => "xmlstarlet"
  end

  test do
    system "#{bin}/xmlstarlet", "--version"
  end
end
