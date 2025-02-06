class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "25.1.0",
      revision: "d56ce97f4de3f85e739a7499bad29871c79b2c03"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c586891b13d7ae78aecdedb0b16f91aa546f4ee6944429d6a36ea429f7384503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c586891b13d7ae78aecdedb0b16f91aa546f4ee6944429d6a36ea429f7384503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c586891b13d7ae78aecdedb0b16f91aa546f4ee6944429d6a36ea429f7384503"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4af267b49ca77b05f6202d5433d6c3e69d64ea027eb1da39d7362713a9ddb35"
    sha256 cellar: :any_skip_relocation, ventura:       "f4af267b49ca77b05f6202d5433d6c3e69d64ea027eb1da39d7362713a9ddb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c586891b13d7ae78aecdedb0b16f91aa546f4ee6944429d6a36ea429f7384503"
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
