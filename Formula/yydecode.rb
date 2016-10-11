class Yydecode < Formula
  desc "Decode yEnc archives"
  homepage "http://yydecode.sourceforge.net"
  url "https://downloads.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz"
  sha256 "bd4879643f6539770fd23d1a51dc6a91ba3de2823cf14d047a40c630b3c7ba66"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a9b97e5fdab56cbcd96ba00c10c81624e8ccb2a61bcf4a41cd104e04318fa4e" => :sierra
    sha256 "db29c3ce942cd4134eaad4ae01084a08311a91b6fbad4f7de0650d77fa77c5aa" => :el_capitan
    sha256 "d9b85d4bb42f2adfb87e3211c39f115d5db3a36afa26c2c4bb233e0a734e84fb" => :yosemite
    sha256 "b9ddc4524b9578b6b7b0809e895ba333f4af7ed06dc24ee3ef874eedd535c6b4" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
