class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.9.0",
      revision: "01662d5fe7dae207e417bcd3183064521e569454"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d6b8b318217d378bf35088d8d0a96e53c70bb3b1ad52afad17d26d9bbe13d68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d6b8b318217d378bf35088d8d0a96e53c70bb3b1ad52afad17d26d9bbe13d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d6b8b318217d378bf35088d8d0a96e53c70bb3b1ad52afad17d26d9bbe13d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "103c9ca40d407756683ef18a91b2e84134650f048b27bf49ddca1244802a236f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "103c9ca40d407756683ef18a91b2e84134650f048b27bf49ddca1244802a236f"
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
