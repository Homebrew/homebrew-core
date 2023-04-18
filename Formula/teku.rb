class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.3.1",
      revision: "a3df3ae1e1d22039f4b179ceff968f9838bc8914"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72a7a8bd28bb149a7cc7190def847b653705f5cfeef31edd41eac9d39438d8ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72a7a8bd28bb149a7cc7190def847b653705f5cfeef31edd41eac9d39438d8ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72a7a8bd28bb149a7cc7190def847b653705f5cfeef31edd41eac9d39438d8ef"
    sha256 cellar: :any_skip_relocation, ventura:        "456e9dcb865573c30c1aecd8dd920f7ffc0056826b06b10280f2833c496ef326"
    sha256 cellar: :any_skip_relocation, monterey:       "456e9dcb865573c30c1aecd8dd920f7ffc0056826b06b10280f2833c496ef326"
    sha256 cellar: :any_skip_relocation, big_sur:        "456e9dcb865573c30c1aecd8dd920f7ffc0056826b06b10280f2833c496ef326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244ac0be80a2437a219bacb289af250c6dd203b3ce87fa95059398a511352ef6"
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
