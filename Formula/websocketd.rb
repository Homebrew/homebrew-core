class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.4.1.tar.gz"
  sha256 "6b8fe0fad586d794e002340ee597059b2cfc734ba7579933263aef4743138fe5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256933f91abb70b0974f791cbbd8158f4399c27ed2ce99438f7ac566a560003e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d9e5282df6737a6870a2a750570ab79909fb4463411797b0bf5d20cb269162d"
    sha256 cellar: :any_skip_relocation, monterey:       "5a769dfeb3f3062af01fb6ba0703e1d416dc648736e20103c1e0a31489796ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbdc36c8c64cb2b0f1f149242a4c82e5d3eebff521e45bdfc88aa7dced9d2440"
    sha256 cellar: :any_skip_relocation, catalina:       "944c9e728f5f1a7ba098207a0acf50b1e19209010c9d87c8cdd18758ec9c71b2"
    sha256 cellar: :any_skip_relocation, mojave:         "28f0108f697e146faec81782988e8fd8bd7162b11e7703578f752f7a51f2b6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74fdd936d2632aaf2e484ef2f796d8d2f4f281f643ab23c414708363116ca9b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}", *std_go_args
    man1.install "release/websocketd.man" => "websocketd.1"
  end

  test do
    port = free_port
    pid = Process.fork { exec "#{bin}/websocketd", "--port=#{port}", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:#{port}"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
