class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.3.0.tar.gz"
  sha256 "dfb86cd8d9be86e665c4b86b68cd7037e4310de001656eef01ec9aeea71edd10"
  head "https://github.com/shadowsocks/v2ray-plugin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "728d56c34b8137617210a56f02e2736151e98b0b8db88d8f88de98c66549013d" => :catalina
    sha256 "c21140db9ed1c21fed0290864f4c1403197afc5f297b00fa516f57bdb28583c4" => :mojave
    sha256 "03c96ba653433c2d38f77b9ae357e2e5018a0bdedd598e09784d395dd51a3b1c" => :high_sierra
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
