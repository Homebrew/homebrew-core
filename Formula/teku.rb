class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.6.0",
      revision: "e434ca3aef36d39a895f21cb89357c20a2335e8c"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c514a08cd9a53012cd85c71a77a37825f9be0594c59c5808d0447a5c34b2cc1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c514a08cd9a53012cd85c71a77a37825f9be0594c59c5808d0447a5c34b2cc1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c514a08cd9a53012cd85c71a77a37825f9be0594c59c5808d0447a5c34b2cc1a"
    sha256 cellar: :any_skip_relocation, ventura:        "86081671c391e18d4419f24dfeba19e03d07103086f7f3d59617bc30890b822c"
    sha256 cellar: :any_skip_relocation, monterey:       "86081671c391e18d4419f24dfeba19e03d07103086f7f3d59617bc30890b822c"
    sha256 cellar: :any_skip_relocation, big_sur:        "86081671c391e18d4419f24dfeba19e03d07103086f7f3d59617bc30890b822c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421419bdd7ccd1bdd8989f7317a41a4494ebdd095a33445faecb2cb9847296ff"
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
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
