class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.7.0",
      revision: "3255b626084d36147a4867ff7cde4467382d512d"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3052693808101b2b9e8ce8719945fc0657b6cc4aee9297f8785dac298d2c0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3052693808101b2b9e8ce8719945fc0657b6cc4aee9297f8785dac298d2c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3052693808101b2b9e8ce8719945fc0657b6cc4aee9297f8785dac298d2c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb3052693808101b2b9e8ce8719945fc0657b6cc4aee9297f8785dac298d2c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58895f45e4d2a212641d974938a16d5083d12b331e687c7727ea8b2c5a6ee654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58895f45e4d2a212641d974938a16d5083d12b331e687c7727ea8b2c5a6ee654"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")

    system "gradle", "installDist", "--no-daemon"
    libexec.install Dir["build/install/teku/*"]
    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env("25")
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    test_args = %W[
      --network=minimal
      --Xinterop-enabled
      --Xinterop-number-of-validators=8
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false
      --data-path=#{testpath}
    ]
    spawn bin/"teku", *test_args
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
