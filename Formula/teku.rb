class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.5.0",
      revision: "32a8074931a927e2ed8300a81601580c022b7eb9"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dadc34b4e0ecb60bbd29decb4256df6c3e558a69e7df890eda96c92fdab7ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dadc34b4e0ecb60bbd29decb4256df6c3e558a69e7df890eda96c92fdab7ba5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dadc34b4e0ecb60bbd29decb4256df6c3e558a69e7df890eda96c92fdab7ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "e9e4b2870ec8ca95dcf822a75f0885007e1ad9aebc6f0a6af11afb4ee3d0039c"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e4b2870ec8ca95dcf822a75f0885007e1ad9aebc6f0a6af11afb4ee3d0039c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9e4b2870ec8ca95dcf822a75f0885007e1ad9aebc6f0a6af11afb4ee3d0039c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc8ccee3c779d26ac67614586b6b5450a34e0b5d1ca453c9fcb53233ee21557"
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
