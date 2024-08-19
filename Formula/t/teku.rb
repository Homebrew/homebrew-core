class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.8.0",
      revision: "777c9dc7bbaa2f563e870b5fa277e48472e234ae"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb08b9036dfc702713e9bb30a635e81855abd6a129de6349e835aae21d19162"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccb08b9036dfc702713e9bb30a635e81855abd6a129de6349e835aae21d19162"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccb08b9036dfc702713e9bb30a635e81855abd6a129de6349e835aae21d19162"
    sha256 cellar: :any_skip_relocation, sonoma:         "a51ab84a805a6c1d87e13d9c83e910a278e00538ba115e4f507e07a9251af9d0"
    sha256 cellar: :any_skip_relocation, ventura:        "a51ab84a805a6c1d87e13d9c83e910a278e00538ba115e4f507e07a9251af9d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a51ab84a805a6c1d87e13d9c83e910a278e00538ba115e4f507e07a9251af9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78332832f5939a67aa448c14927a0723c6d7752afd07ad025bf13f098042654"
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
