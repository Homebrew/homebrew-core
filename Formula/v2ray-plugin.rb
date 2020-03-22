class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.3.0.tar.gz"
  sha256 "dfb86cd8d9be86e665c4b86b68cd7037e4310de001656eef01ec9aeea71edd10"
  head "https://github.com/shadowsocks/v2ray-plugin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee3169521266e5bf5140bec4a3bc1ad573d965bb46c23fff22697bc257d9dfb7" => :catalina
    sha256 "3c74254d3ea548d60bb3f7287ef8109a4cce77434edba3d61ddffa8b43f107a5" => :mojave
    sha256 "a4f3f9651cba61a169de22cb0e933675baacd7089d8db69f91acf92e3f9e5fab" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", "-o", bin/"v2ray-plugin"
  end

  test do
    server = fork do
      exec bin/"v2ray-plugin", "-localPort", "54000", "-remoteAddr", "github.com", "-remotePort", "80", "-server"
    end
    client = fork do
      exec bin/"v2ray-plugin", "-localPort", "54001", "-remotePort", "54000"
    end
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
