class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.3.0",
      revision: "51807fbf17f15f343a0d84aa9fadaf6dc64c30e5"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a3267a2aa42ccd8ec775d29863b8199dc50c8021199313a0178eaca4195f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12559627075763aae102636f3750cfcc6d6e5dc3ce0020514f8777f0e4eeb531"
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
