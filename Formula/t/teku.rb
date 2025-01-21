class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "24.12.1",
      revision: "b5dd2ae7c7e15d351521f644dec662e50a9f7e3e"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467d5d5e298111902d69c503521058e30ba6fa1ff37e9da32158a0b2107c4e94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "467d5d5e298111902d69c503521058e30ba6fa1ff37e9da32158a0b2107c4e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "467d5d5e298111902d69c503521058e30ba6fa1ff37e9da32158a0b2107c4e94"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9adc8d3d88295278463190607280f60260b1d1848beae1f3f0fc0631ea56754"
    sha256 cellar: :any_skip_relocation, ventura:       "c9adc8d3d88295278463190607280f60260b1d1848beae1f3f0fc0631ea56754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467d5d5e298111902d69c503521058e30ba6fa1ff37e9da32158a0b2107c4e94"
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
