class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.5.0",
        revision: "8f80286572d395f547dca4d4ed228672a85203cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392f29a95f2d3d9d11fb5ab5c5983dd3672155f4f185d98e1e52d7c72ae93641"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "843e431385c7f5d3404489ce8ee51a38b9d7b8410fe4349f2e17a3efe6d1a2f2"
    sha256 cellar: :any_skip_relocation, monterey:       "3187d9c1dbe0fa4aa8dd1d2880a1511a3292cb0fa1e19571fa697c8cb83f4703"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e7d4bbf312bc4a554536dd06e66e82b5baaf830a2f79ab157a7f8cb460ae5ab"
    sha256 cellar: :any_skip_relocation, catalina:       "3c6fe4f81ccb725b2efc807af9bd6e95e4cacbe436e34c31f16c9f93d060f73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad76a799321f5c56bfbb97b4a8c1755e1e05fa18154acd52f35871f27df8ce56"
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
