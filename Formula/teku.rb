class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.5.1",
        revision: "8f97fa59e2c18b9d2029853d19a25fd9b6646e61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "827568ba41a14f756d60ccb400b162088702387176d51bc230f3c0c7acc353d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde5942e83048ed6fc8d4982b6164face83ea4b2d8db4a2783524991fe7eb47f"
    sha256 cellar: :any_skip_relocation, monterey:       "29285e3aeee5193efd2ebf0854086a4018b958400635938a6df3d79a1db38413"
    sha256 cellar: :any_skip_relocation, big_sur:        "58a0877efbbdeb55ab558817c0005b1f2820ebd60dda5a0526ebb34ff8f5a1ed"
    sha256 cellar: :any_skip_relocation, catalina:       "f59656b7a1825c346e917cc572c5d928ccb273fd19d1768959f5a891de4b0003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1da0a118d29442b3b57d374c26fe4f8ecbbf527bf0bf29a8177e579689d4c59f"
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
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
