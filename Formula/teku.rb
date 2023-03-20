class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.3.0",
      revision: "e895b424cba784ad987d1c2db49e1c30e0432c56"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee503d61217191edde246a7b86b6d17273e4294c4ce84d4fb9cd258fdb1e9e01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee503d61217191edde246a7b86b6d17273e4294c4ce84d4fb9cd258fdb1e9e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee503d61217191edde246a7b86b6d17273e4294c4ce84d4fb9cd258fdb1e9e01"
    sha256 cellar: :any_skip_relocation, ventura:        "669216d3ce355feb9d1bdb3eb66514d6e0765b31f7610c4334d08171c8210fae"
    sha256 cellar: :any_skip_relocation, monterey:       "669216d3ce355feb9d1bdb3eb66514d6e0765b31f7610c4334d08171c8210fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "669216d3ce355feb9d1bdb3eb66514d6e0765b31f7610c4334d08171c8210fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d732d0d8715565e32875c5b4d0167765e1f68a2df17e6fd851d305ec5e555b4b"
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
