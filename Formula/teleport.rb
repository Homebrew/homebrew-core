class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.4.tar.gz"
  sha256 "970be2acce6aadf003c018d4e47daab0d609b390f39fa245c04a35c7dac75950"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e18b50b89b643597b1018cce0c1ba30f2e531d64b394b3171f28d849f4c12d9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c968b7d9658aa52266a07534559b27f398c1ea378de9dfefb7c8d78b724de19"
    sha256 cellar: :any_skip_relocation, monterey:       "a67e9cad808099b87977507c04fba1196610077205c0238fb53b7681599a7eef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebe2deea95b7276227342ed1ed26ba0a2f3e3b2d6b38efb0303110a485c37bfc"
    sha256 cellar: :any_skip_relocation, catalina:       "e4c56b595c76496009b9e1ce7691944a026654f2eb17f7fba0cc591287a90d1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200b47b3496c349e57d41fc61bb4bb32851cd2ccf1f07b7bdca2be2f90e3f3e1"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/ea3c67c941c56cfb6c228612e88100df09fb6f9c.tar.gz"
    sha256 "66812b99e4cc00d34fb2b022ffe9d5e13abb740a165fcf3f518dada52c631c51"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    webassets = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match resource("webassets").version.to_s, webassets
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
