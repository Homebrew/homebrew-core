class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.6.1",
      revision: "6c8bd1265548e13f0e3cf1767bab152c10f6714b"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "744001660edf3f41f8dbe6d3d8c1ca4248954b8c5c36af3be5ae904198432d70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "744001660edf3f41f8dbe6d3d8c1ca4248954b8c5c36af3be5ae904198432d70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "744001660edf3f41f8dbe6d3d8c1ca4248954b8c5c36af3be5ae904198432d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "744001660edf3f41f8dbe6d3d8c1ca4248954b8c5c36af3be5ae904198432d70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e665b5b7b622f1e173f3e7f276a64ea8cbe16686b3af9c51a7e5e566b7251aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e665b5b7b622f1e173f3e7f276a64ea8cbe16686b3af9c51a7e5e566b7251aa4"
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
