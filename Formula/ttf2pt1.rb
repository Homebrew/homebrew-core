class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "http://ttf2pt1.sourceforge.net/"
  url "https://downloads.sourceforge.net/ttf2pt1/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e70efa3a1b28b212ea2366ac50b33fbf48e9b7922d03f1a6b86965af87244bee" => :sierra
    sha256 "0ef606dfb439ad46c5442b35458f009e864ee3270145c7be940581a5d272bc54" => :el_capitan
    sha256 "65c1456cab73a91161e4dddbc4f04842029a810a8e4e4c396e90fbf039e61f60" => :yosemite
    sha256 "c81f56318e2311c422c1a53647650478660ec16fc935380c01cf10c1f53edd73" => :mavericks
  end

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end
