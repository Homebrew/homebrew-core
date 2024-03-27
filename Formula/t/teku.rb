class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.3.1",
      revision: "508459f21f4d5faab773b011a2f8196749942b00"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, ventura:        "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, monterey:       "b8dab6e0b66510f8a10d863ad6cb707c5abe62937f2873c2fe55c22ff5306c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9858cf3a124862f4ae942cd4b32b94a1d6b973e66692cc316a0a312e716cd10d"
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
