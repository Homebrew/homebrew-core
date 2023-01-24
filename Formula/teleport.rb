class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.2.3.tar.gz"
  sha256 "27e540b558c96bbf5352d6f682cde921d9fe6d68cd54d5f0f72fa6d46259e99c"
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
    sha256 cellar: :any,                 arm64_ventura:  "292311af2d8b82c1b686e981456caa4d83407adc43b91a45aaf61c03282144cf"
    sha256 cellar: :any,                 arm64_monterey: "b7bc4bbeafbc5a519e1db62394e13544da047fd319eb6a7366532a74d1986aa9"
    sha256 cellar: :any,                 arm64_big_sur:  "f5b93a930eb97d84f3049abfe8594f0ca25192f6e856e000d51bd187f1a1fbfb"
    sha256 cellar: :any,                 ventura:        "2eea96cc106b79a4d33402c280abbf233eebf8c931528911550892e05fe21a72"
    sha256 cellar: :any,                 monterey:       "14bf1bc68cfdd089fc5b0e4e82ff50b604fa125e6540e327e9523207eb22cabc"
    sha256 cellar: :any,                 big_sur:        "d6221ca618ba322dbc56c5236e541bba8e52091548fc27c104895cb329859c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27522300f101d34d7623811131ee9a8c98274497834d5d24809f02d4324b729f"
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
    url "https://github.com/gravitational/webassets/archive/cbddcfda9d5ccba11f02ee61bd305c1f600ee6b0.tar.gz"
    sha256 "7ce987ffb160fe9bf27f1021613216273a531849a42a773947b947e772d3ec45"
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
