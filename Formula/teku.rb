class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.1.1",
      revision: "664537cdc232ae28ac61c52d7fd6d6c99f5c55d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, ventura:        "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, monterey:       "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, big_sur:        "25785acd4818dc99693ea962fa323cac75077550078dd5dbe4ac0d00b3a3357c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51127258744ad442bd52b0ee863d3d81b6076df4f311e3921733d59bf3397bd2"
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
