class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.8.0",
      revision: "8882b2f0585a93e215f1603a520c5c53ccc174c2"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcbeec4d48cf8f84ee649781e5d48ad52588b3c3088ca991b1b708b7f80368fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcbeec4d48cf8f84ee649781e5d48ad52588b3c3088ca991b1b708b7f80368fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcbeec4d48cf8f84ee649781e5d48ad52588b3c3088ca991b1b708b7f80368fb"
    sha256 cellar: :any_skip_relocation, ventura:        "d9a7051c9f11f8f072a3d5a6194a25e9888cfeb62ebb04ea25ab21ccdf6a3bac"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a7051c9f11f8f072a3d5a6194a25e9888cfeb62ebb04ea25ab21ccdf6a3bac"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a7051c9f11f8f072a3d5a6194a25e9888cfeb62ebb04ea25ab21ccdf6a3bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1061721c6c5a7a3147389e59611e56481d3396b697736d8640497e4cd9dca59c"
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
