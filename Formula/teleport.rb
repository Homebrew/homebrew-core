class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.3.7.tar.gz"
  sha256 "63d0ba8756c013c9ca76a902561f8af56d8c9b5a038189d79725f951d2217a38"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fe1f7a81ea5251f37c895ef2244dcedafe9314aaa6f35c9b8150c75717af96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c60a35577ba24d76231de7bca532df5d34e464d597c0cad599dd3582c2723b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "273fda867e0968108a70b16d3710e0266e17e375272f94de92aa2dfb5e936b4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd154d85999e4837812166c2315dff726f276697ca8e6eed65d338f7c1fa5b8d"
    sha256 cellar: :any_skip_relocation, catalina:       "85a1f1b07756275ac35505ac249d10b4b783f64ec6eb9d5f52f8b4afdcc7b7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e6bc6fe69792e511ec2e741214aa4b31f16ba09cebbfe299d11f3a6e62cccd"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/6e79f9805b7659b2d59bc4ba7c30a92072efcf7b.tar.gz"
    sha256 "305117f1162ac02cb65c28334f982f2bae4855c230fc471e8858950461cf05df"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
