class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.3.1",
      revision: "508459f21f4d5faab773b011a2f8196749942b00"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80ea44b88515e27199f137e66f6e792ad11608fabd3848736ce9cb400f778783"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80ea44b88515e27199f137e66f6e792ad11608fabd3848736ce9cb400f778783"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ea44b88515e27199f137e66f6e792ad11608fabd3848736ce9cb400f778783"
    sha256 cellar: :any_skip_relocation, sonoma:         "a162a399707ebbb4fba81a54279f90abdd26c7b46027cd8ad5959d0636b06b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "a162a399707ebbb4fba81a54279f90abdd26c7b46027cd8ad5959d0636b06b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "a162a399707ebbb4fba81a54279f90abdd26c7b46027cd8ad5959d0636b06b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ea44b88515e27199f137e66f6e792ad11608fabd3848736ce9cb400f778783"
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
