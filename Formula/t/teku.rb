class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.10.1",
      revision: "115ab400185bebee063ce13d0ab7f9f80b296c4e"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36b30246cc0a5bbeb419e0c7b5e3e84bdd03e10e2cb93cfef42b9ab75ebf5830"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36b30246cc0a5bbeb419e0c7b5e3e84bdd03e10e2cb93cfef42b9ab75ebf5830"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36b30246cc0a5bbeb419e0c7b5e3e84bdd03e10e2cb93cfef42b9ab75ebf5830"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "09d771c3354d711d1f87a6e3c55965b24201e6d72cb3289519438372d5f55dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "09d771c3354d711d1f87a6e3c55965b24201e6d72cb3289519438372d5f55dfa"
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
