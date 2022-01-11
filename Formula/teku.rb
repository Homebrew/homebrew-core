class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
        tag:      "22.1.0",
        revision: "5b85ef197f5468c32b4aeb869ebe74201b9875bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97c4812694ee813a13e31c262f0a96a81a487e23d86065b6aea8096b2868f346"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17b9b1daaf04d9b9eb5a58af1a6491370604d85d2be8775e80d61622699b6166"
    sha256 cellar: :any_skip_relocation, monterey:       "6642ee3a33ee28091e5383a12ccd61f7ae99126ec79bf9c452ede5c7ae79c4ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df91c28062d0f89de22e1c83fa667c9b9b936cefe74e17df28da1fac7f60753"
    sha256 cellar: :any_skip_relocation, catalina:       "84f38e89404ec53d5219e4c96138a3c93448a842f6fce5c7a8fd50a6fe766ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a63323115c7087dab604abb812ca1a58e9948a68c22f5319778adf7726ed38"
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
