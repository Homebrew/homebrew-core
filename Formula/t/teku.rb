class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "26.8.0",
      revision: "b37812f9ff3ac75d898335dea11cf4cf47e6f983"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56efef952b223060c9215a94ec764a825ad01f58b453ccfa27cf94dff7367a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56efef952b223060c9215a94ec764a825ad01f58b453ccfa27cf94dff7367a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56efef952b223060c9215a94ec764a825ad01f58b453ccfa27cf94dff7367a4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56efef952b223060c9215a94ec764a825ad01f58b453ccfa27cf94dff7367a4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be08f9d5773428c71be2efde9c6d0efbfeb02dbd7188ff336cd3ff736d1d8bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be08f9d5773428c71be2efde9c6d0efbfeb02dbd7188ff336cd3ff736d1d8bb4"
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
