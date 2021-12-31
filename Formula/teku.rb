class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "21.12.2",
        revision: "a443c80dd686092e535b1e37c26b8ba50234b223"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bdb86599a5102ce0bbd8ee05a098b79984ed3b5e0282ca1e19c96362dae98ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84e498231cd8f34ffe9a805824934cb21c2b1d5e42ba429ad8ac1cd6d52f8bea"
    sha256 cellar: :any_skip_relocation, monterey:       "1fe8a4709b1417f64a05a0743ee685a0480b2b20bdf40543b3d877baa8c2e714"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdbfac65edae03a4a54343aa5a04cfc33c3e038af65b174d6e3b329a2839a59"
    sha256 cellar: :any_skip_relocation, catalina:       "81b7c2f8b657cc7ad95b448a4320c3c382e5f68375f61028f45161511a301617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "650bcdbcc039721899dca388a83b79ead91fce8d035db9d6921d961a9331bd6a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
