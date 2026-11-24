class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.11.0",
      revision: "ee3fd196a5767c3a2fb205841b502b603c2d872f"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    manifest_sha256 "bbb8047f316a33d96730706c92414e2c0de48ada5dacab9dd7d894caa60ede7d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7417b0afcbd95fd2b4421a68363fc44ca9580c1f0d4fc6ab96d0c6de680b98e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7417b0afcbd95fd2b4421a68363fc44ca9580c1f0d4fc6ab96d0c6de680b98e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7417b0afcbd95fd2b4421a68363fc44ca9580c1f0d4fc6ab96d0c6de680b98e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0343dcbfeed9cb24c220aa46d52696c41f211fec8cd4ab03f0ca7961e8e15380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0343dcbfeed9cb24c220aa46d52696c41f211fec8cd4ab03f0ca7961e8e15380"
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
