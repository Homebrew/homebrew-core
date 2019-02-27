class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.0.tar.gz"
  sha256 "5320eff71d99edcfa1e5e883debb42c50ccdebc2b43eb30c6c1b16baa632cda2"

  bottle do
    cellar :any_skip_relocation
    sha256 "89202ce48d55907a50d47bedd73f14eb869fec36c1777ae9a5f207dafa33809a" => :mojave
    sha256 "3ae2a7b892bb639201569144ccac8f00992cd07b858c9ddf0ff61768a6db3ff3" => :high_sierra
    sha256 "e688d94954a982e397a22241755fd25591bd1ae6fbffa46328289458376ef309" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"v2ray-plugin"
  end

  test do
    server = fork { exec bin/"v2ray-plugin", "-localPort", "54000", "-remoteAddr", "github.com", "-remotePort", "80", "-server" }
    client = fork { exec bin/"v2ray-plugin", "-localPort", "54001", "-remotePort", "54000" }
    sleep 2
    begin
      system "curl", "localhost:54001"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
