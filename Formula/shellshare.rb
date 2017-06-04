class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.2.tar.gz"
  sha256 "37c452bb87f89f2bce08da49155c88574303aba40c051c6fbff293f5afd4e0dd"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
