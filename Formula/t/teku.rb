class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.10.2",
      revision: "e38dcce2eea1a42fff699d58aa27b5db37038ad9"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc9551b4256003f8f162f8214a6e5f800fae1b4adb447c15b7c0508748675ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc9551b4256003f8f162f8214a6e5f800fae1b4adb447c15b7c0508748675ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc9551b4256003f8f162f8214a6e5f800fae1b4adb447c15b7c0508748675ae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "72f428a1e7c015057039117bb4f985e5f4302f5fda013e64c602793f0260bef1"
    sha256 cellar: :any_skip_relocation, ventura:       "72f428a1e7c015057039117bb4f985e5f4302f5fda013e64c602793f0260bef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc9551b4256003f8f162f8214a6e5f800fae1b4adb447c15b7c0508748675ae5"
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
