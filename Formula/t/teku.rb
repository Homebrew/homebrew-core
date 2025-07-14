class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "25.7.0",
      revision: "958ed19401bafd192a1c9006a719a3e9ee96efdb"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993eb6e5c723a9fc3646290f054828bd2fcc445d885ce90c3ad48cda87b2b43d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993eb6e5c723a9fc3646290f054828bd2fcc445d885ce90c3ad48cda87b2b43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "993eb6e5c723a9fc3646290f054828bd2fcc445d885ce90c3ad48cda87b2b43d"
    sha256 cellar: :any_skip_relocation, sonoma:        "89fcb00f07412d146ce8389bfb2d4392f82b43ffc7f484dbf2caf740aaae11dc"
    sha256 cellar: :any_skip_relocation, ventura:       "89fcb00f07412d146ce8389bfb2d4392f82b43ffc7f484dbf2caf740aaae11dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993eb6e5c723a9fc3646290f054828bd2fcc445d885ce90c3ad48cda87b2b43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993eb6e5c723a9fc3646290f054828bd2fcc445d885ce90c3ad48cda87b2b43d"
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
