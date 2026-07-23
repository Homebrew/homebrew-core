class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.7.1",
      revision: "924baf655e6a429dbdc43d7764861cf8960af1c5"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88cd02a4872bb9298692c78957c1474804aed0c7fcf185852156376cb67d203e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88cd02a4872bb9298692c78957c1474804aed0c7fcf185852156376cb67d203e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88cd02a4872bb9298692c78957c1474804aed0c7fcf185852156376cb67d203e"
    sha256 cellar: :any_skip_relocation, sonoma:        "88cd02a4872bb9298692c78957c1474804aed0c7fcf185852156376cb67d203e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f529172e15159a248382c6a40a05121144e98c44c950f08df3c2dee242b48946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f529172e15159a248382c6a40a05121144e98c44c950f08df3c2dee242b48946"
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
