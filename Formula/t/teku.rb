class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.10.3",
      revision: "9591436143efd2b0e457ea2b6614eee678fca770"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "908b51f2fe9ba79471f3ebb9a1f1337e798e6fd4b010d1c4a96b1df9f59c929d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "908b51f2fe9ba79471f3ebb9a1f1337e798e6fd4b010d1c4a96b1df9f59c929d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "908b51f2fe9ba79471f3ebb9a1f1337e798e6fd4b010d1c4a96b1df9f59c929d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b71b9039bb27ac193e3b23509ed83cd5344fc29b497c1b79453fea9b5fbaa97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b71b9039bb27ac193e3b23509ed83cd5344fc29b497c1b79453fea9b5fbaa97a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    system "gradle", "installDist", "--no-daemon"
    libexec.install Dir["build/install/teku/*"]
    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env("25")
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    test_args = %W[
      --network=minimal
      --Xinterop-enabled
      --Xinterop-number-of-validators=8
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false
      --data-path=#{testpath}
    ]
    spawn bin/"teku", *test_args
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
