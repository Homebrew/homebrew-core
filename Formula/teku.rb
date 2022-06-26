class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.6.0",
        revision: "e8382813880512dd26d0a58a22da0efcdba0b420"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0d2ad570f561cd537185016515a10fb8d59b122eb855e6cfb5876a296deb58a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db6df011ab802eb3400265de5c53bdf4976ac8082776cdc428f0a40803cd568"
    sha256 cellar: :any_skip_relocation, monterey:       "f7648197b089c658f030d18fea8c6a37ad221b167679bc3a542bada0dc6dcb90"
    sha256 cellar: :any_skip_relocation, big_sur:        "473a367c527e5f64b7a31772f03ecd95a1f90f16eb9792bd94bee2ab505ed68a"
    sha256 cellar: :any_skip_relocation, catalina:       "b3e04e4cfaa37c4e64a69953270f81dafae94554287ad2dd783f5fea349b3749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f1694b336706f84417711540972f6a0255755cebbe0564d2f8949a32370746"
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
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
