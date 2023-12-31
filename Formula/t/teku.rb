class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "23.12.1",
      revision: "f3d80b3c42349f2b4b3461527c3e973d0ada2852"
  license "Apache-2.0"
  head "https://github.com/ConsenSys/teku.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfb5f789d2c77ff12cfe0f6214b1b92e237692e3d9ecd222cd6fa0c0dc00329c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfb5f789d2c77ff12cfe0f6214b1b92e237692e3d9ecd222cd6fa0c0dc00329c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb5f789d2c77ff12cfe0f6214b1b92e237692e3d9ecd222cd6fa0c0dc00329c"
    sha256 cellar: :any_skip_relocation, sonoma:         "124d430e910c21b2290212a654680128a25fd9f055656dbf6fe2fef267588388"
    sha256 cellar: :any_skip_relocation, ventura:        "124d430e910c21b2290212a654680128a25fd9f055656dbf6fe2fef267588388"
    sha256 cellar: :any_skip_relocation, monterey:       "124d430e910c21b2290212a654680128a25fd9f055656dbf6fe2fef267588388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb5f789d2c77ff12cfe0f6214b1b92e237692e3d9ecd222cd6fa0c0dc00329c"
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
    test_args = %W[
      --ee-endpoint=http://127.0.0.1
      --ignore-weak-subjectivity-period-enabled
      --rest-api-enabled
      --rest-api-port=#{rest_port}
      --p2p-enabled=false

    ]
    fork do
      exec bin/"teku", *test_args
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end
