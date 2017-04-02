class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
  version "1.5beta7"
  sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

  bottle do
    cellar :any
    sha256 "c2d7b7b4d4274897669112375be7873f7387b729c66023ae81a5cb5a518786d5" => :sierra
    sha256 "e45c866a01dd651b307b0f83798adbd2f53b9fa1ca4be3b0e830adcf3df67e66" => :el_capitan
    sha256 "e44ef687b867ae96dbce19cdc305eb8561b076758690b300ea97552092de578e" => :yosemite
    sha256 "1df9e820ccefadd97512902853c9849dfe29598b361be548202a7e32a77a3b35" => :mavericks
  end

  depends_on "libnet"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    tcptraceroute requires root privileges so you will need to run
    `sudo tcptraceroute`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end
end
