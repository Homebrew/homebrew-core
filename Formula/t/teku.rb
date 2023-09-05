class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.9.0",
      revision: "cd1961becf8e9e6c658fdfc4d47b586cb2690c23"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1b6404c783fccd49d951db6c0b7a61f3ea84a20b74cb4f83731fb57138fb41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb1b6404c783fccd49d951db6c0b7a61f3ea84a20b74cb4f83731fb57138fb41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb1b6404c783fccd49d951db6c0b7a61f3ea84a20b74cb4f83731fb57138fb41"
    sha256 cellar: :any_skip_relocation, ventura:        "159f777b21df2c647820a8be458f5612a69e58955328ebfb2d3ad7ad8765e755"
    sha256 cellar: :any_skip_relocation, monterey:       "159f777b21df2c647820a8be458f5612a69e58955328ebfb2d3ad7ad8765e755"
    sha256 cellar: :any_skip_relocation, big_sur:        "159f777b21df2c647820a8be458f5612a69e58955328ebfb2d3ad7ad8765e755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d74410d9a30626115cc8f1bb5726d13ae519a28116155c928a1d120d76d1876"
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
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
