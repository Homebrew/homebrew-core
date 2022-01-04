class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.1.0",
        revision: "5b85ef197f5468c32b4aeb869ebe74201b9875bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "455607ee40deb115cad841ada71289c1adb0f97fb93cc781196152ab895fb56d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65c5bf41bdc3fe5244cfa3fe13a688f752d1dee60b7d5a2793d778a1e534de97"
    sha256 cellar: :any_skip_relocation, monterey:       "dff4186bcae95e50d6102803a30895e18c04ad904c1013baf12796a47cf1db9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "af14865fda7f4c5108c417ca53e76eadb4831be0d748d8cf87aeecde47f67065"
    sha256 cellar: :any_skip_relocation, catalina:       "41790080ac204a0e7775e41034b1aa418cbc8d414f366aec47579f11a23b5208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1849f777bd999a03665900680f0b1c639ef921a3faaddaea4bc12eda00e4285a"
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
