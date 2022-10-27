class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.0.1.tar.gz"
  sha256 "07f311b764fd1b59d26c1600e4e1966f548a40bb265a70f5ffba12853b0c9751"
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
    sha256 cellar: :any,                 arm64_ventura:  "3926b5a367ee46b9322504863ee0c2cc3b33551886198facd4d40c84bf7d8373"
    sha256 cellar: :any,                 arm64_monterey: "60cf242d02dcb279b22f29789fc6a1edfedcdc1c3acae70a222adb6134d57380"
    sha256 cellar: :any,                 arm64_big_sur:  "da516c2585cc9781ba9efbfe249f89696583bc4a7ef698b85bfc2bfee97cb1bb"
    sha256 cellar: :any,                 monterey:       "f2165cac1855214b9b77cba896d899b025f2bd7523640f60b510f835223153f6"
    sha256 cellar: :any,                 big_sur:        "9b713197f4cb80eb9fe474fae8030c92837a2924d90005d075598dc362fc6295"
    sha256 cellar: :any,                 catalina:       "ee8a7a852af7d8be2e67f38b0d22b4e3b64c566f283cee6ed43978cd4eb47935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3aa4a429b849b986e74cfe62e5af1fdc66df6b551a2b7289bb4da94db42ee21"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/53bae5e9307323dca1e506337dcaefd7cc1573a9.tar.gz"
    sha256 "adaa169996a2b6bc2c1d45ed2a380ea0c63e8d958b560741509df1590d5b93f8"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
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
