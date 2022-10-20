class V2rayPlugin < Formula
  desc "SIP003 plugin based on v2ray for shadowsocks"
  homepage "https://github.com/shadowsocks/v2ray-plugin"
  url "https://github.com/shadowsocks/v2ray-plugin/archive/v1.3.1.tar.gz"
  sha256 "86d37a8ecef82457b4750a1af9e8d093b25ae0d32ea7dcc2ad5c0068fe2d3d74"
  license "MIT"
  head "https://github.com/shadowsocks/v2ray-plugin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e881a144403b3d336c0d652601342580a9f67724647e46e2eaaa36e8408c70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ff4ac95fa05cc7d11429495c27eb499a6b2539fc6306eda02593a3dbd2c3b9a"
    sha256 cellar: :any_skip_relocation, monterey:       "73aac43594414ae1109fbf9715166544d0a6acb6d1f6a98d725eed932ed14840"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a3064ead8cb35a8951619e5899f4ddbeff48a0e504bf156d8325079fe5c642a"
    sha256 cellar: :any_skip_relocation, catalina:       "891f541e150a393ff20caa78eb79ef12f60929fb9e5b35826e2e639c46a61dc2"
    sha256 cellar: :any_skip_relocation, mojave:         "cb8ff7b812aa561f9e23935461968ba1c26cbe393c599aab4e1753b37702748b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f11b330c3dc9c445b757188057c93ce94de89f03f4adfa1a8c6405f5ba66b400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ad295c462b215b5a36d4b8087f03675ef1e0e1508d53dfb96c63bc0be688d8c"
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
