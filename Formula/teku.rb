class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.2.0",
      revision: "7a4abc6f913bc16ee9e1fe1cdc85b8047f5204fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, ventura:        "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, monterey:       "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, big_sur:        "08ab22d78ef5388c99041f5cbf6c335d83e93d1931255e8e8900c225ee536df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c906e9c39f62dc68959cba9e7ed96853375362f9b5a9f2b7837cac47686ac7f"
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
