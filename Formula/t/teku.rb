class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "25.4.0",
      revision: "5b806dd3ea2bd7e9c32cfa15ad633837b1e793c2"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c26f867d47652a42f84f2d7587f83e5cb660674f9e6abfa42df29254899570da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26f867d47652a42f84f2d7587f83e5cb660674f9e6abfa42df29254899570da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c26f867d47652a42f84f2d7587f83e5cb660674f9e6abfa42df29254899570da"
    sha256 cellar: :any_skip_relocation, sonoma:        "739645eef0602814fb6409d2762cd17b87755d66387b56e27fc7f7416f4f1a72"
    sha256 cellar: :any_skip_relocation, ventura:       "739645eef0602814fb6409d2762cd17b87755d66387b56e27fc7f7416f4f1a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c26f867d47652a42f84f2d7587f83e5cb660674f9e6abfa42df29254899570da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26f867d47652a42f84f2d7587f83e5cb660674f9e6abfa42df29254899570da"
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
