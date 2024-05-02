class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.4.0",
      revision: "cdcb17736cefdfeb0233d972956625a164f5b3a1"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1a8fdad544b08342ec713ed2dec4e4b37fcd1a1892e2bdd49e38e45a3a7e812"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1a8fdad544b08342ec713ed2dec4e4b37fcd1a1892e2bdd49e38e45a3a7e812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1a8fdad544b08342ec713ed2dec4e4b37fcd1a1892e2bdd49e38e45a3a7e812"
    sha256 cellar: :any_skip_relocation, sonoma:         "74139ac03fcc182fa6dddaa89dacaafd3f556229e7dd1dba8e0ef1ba6ed80525"
    sha256 cellar: :any_skip_relocation, ventura:        "74139ac03fcc182fa6dddaa89dacaafd3f556229e7dd1dba8e0ef1ba6ed80525"
    sha256 cellar: :any_skip_relocation, monterey:       "74139ac03fcc182fa6dddaa89dacaafd3f556229e7dd1dba8e0ef1ba6ed80525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1a8fdad544b08342ec713ed2dec4e4b37fcd1a1892e2bdd49e38e45a3a7e812"
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
    test_args = %W[
      --ee-endpoint=http://127.0.0.1
      --ignore-weak-subjectivity-period-enabled
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false

    ]
    fork do
      exec bin/"teku", *test_args
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
