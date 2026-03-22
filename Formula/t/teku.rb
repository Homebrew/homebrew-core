class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.3.0",
      revision: "db53981bd18680729f06f99a07b87cb6aad3382e"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30f6bfe434ba4e9d9c706be8c9fc088f72b5d77901b2667f5d4404bc92a9db3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30f6bfe434ba4e9d9c706be8c9fc088f72b5d77901b2667f5d4404bc92a9db3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30f6bfe434ba4e9d9c706be8c9fc088f72b5d77901b2667f5d4404bc92a9db3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "30f6bfe434ba4e9d9c706be8c9fc088f72b5d77901b2667f5d4404bc92a9db3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c5f7e2ad3464ee41d1555a2a9f539ed77bb621d21f3e8057db229601de793f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c5f7e2ad3464ee41d1555a2a9f539ed77bb621d21f3e8057db229601de793f"
  end

  depends_on "gradle@8" => :build
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
