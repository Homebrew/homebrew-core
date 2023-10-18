class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.10.0",
      revision: "121c1487a3694854d9024dd48b09009adaf6af06"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24b413ac9343c80fea29cef0a947e18b3ec94c9e6cbeceaefaea9bfc46feaded"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24b413ac9343c80fea29cef0a947e18b3ec94c9e6cbeceaefaea9bfc46feaded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b413ac9343c80fea29cef0a947e18b3ec94c9e6cbeceaefaea9bfc46feaded"
    sha256 cellar: :any_skip_relocation, sonoma:         "faa379b70eb1198e75285dd39af28237abeccfad170561572bc36ad20b4cd2e4"
    sha256 cellar: :any_skip_relocation, ventura:        "faa379b70eb1198e75285dd39af28237abeccfad170561572bc36ad20b4cd2e4"
    sha256 cellar: :any_skip_relocation, monterey:       "faa379b70eb1198e75285dd39af28237abeccfad170561572bc36ad20b4cd2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ba20f42c56a9bd6666d2f386ad51f4388cf7b84ee7352d8d603ea70867e7273"
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
