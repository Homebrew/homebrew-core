class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.9.1",
      revision: "78a929fa0bbe76eaac8d2bdd3dcea9d9125db28f"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84c2ed1ccb03057189d947d65323e5806fd124b5a5e916245b72c401a7aa58d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b84c2ed1ccb03057189d947d65323e5806fd124b5a5e916245b72c401a7aa58d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b84c2ed1ccb03057189d947d65323e5806fd124b5a5e916245b72c401a7aa58d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b84c2ed1ccb03057189d947d65323e5806fd124b5a5e916245b72c401a7aa58d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab0d37f21147fe357e8731e1010b2dfa1f8e8ff7c2c734c844406ad7161138f6"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0d37f21147fe357e8731e1010b2dfa1f8e8ff7c2c734c844406ad7161138f6"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0d37f21147fe357e8731e1010b2dfa1f8e8ff7c2c734c844406ad7161138f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab0d37f21147fe357e8731e1010b2dfa1f8e8ff7c2c734c844406ad7161138f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd13ed3d39ae415e3e3c8bd89f10a72c23dc76b798b2b4a46cdd094351514c4"
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
