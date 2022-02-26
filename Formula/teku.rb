class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.1.1",
        revision: "664848613b3d8f3d26bb52eed5009a0ea44eb0b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "609acad5aae95ca53d28431b4d768c61a58f54ab6ac0cb81e03505e53cbdd64c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0934edc7d3fdd5a6c275b4ef118e59ea1d75c0ca3d1c8cb1d8bc60ab01db845d"
    sha256 cellar: :any_skip_relocation, monterey:       "b79298e605187b3e7515a4cf252c3e747079d164c358dbdcd07212a0b95cce7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dacd229e28c2eb01024cbd0bb6e2be9c4644c2667a79883a37e22661b990c2f"
    sha256 cellar: :any_skip_relocation, catalina:       "a12ef07b46dd027f0c82ef97454f3ccd23f9f41448fa1e0db2822fe17260fe47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "390668d2f21ee7a6face14cfefb3adc4177a7266ca423c369d2c4ac5e3cf190a"
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
