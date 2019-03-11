class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.3.tar.gz"
  sha256 "d984a413c3b1f785265430519e9b1eecc6e47b96d63f5b207f82872dab0a0765"
  revision 1

  bottle :unneeded

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
