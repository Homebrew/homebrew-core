class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.2.0.tar.gz"
  sha256 "3009452515723f68ab4b95fd154b51937bbf01feae2464a7055af2e5183d870b"
  head "https://github.com/shadowsocks/v2ray-plugin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23213349b935a05f0ae927631598fa7295dc1cf2112abacd0f6bc27964062334" => :mojave
    sha256 "c3c69fecbecc40ecc495eca5253b922f205fa91f20cd2e09f4e3d3522065d0af" => :high_sierra
    sha256 "e1c311e9aa7ae802a2b3740458167d00b66693c73d92b2db7f85d4302ad4c256" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", "-o", bin/"v2ray-plugin"
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
