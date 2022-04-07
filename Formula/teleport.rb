class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.0.4.tar.gz"
  sha256 "4b5b8f636fbd87e2ca7bfa32ac15ddac7ff79687bb079cd01da677f07bd72488"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bd14a865aab01e63d5e7535db6ebc101b01a9773741c66588cb816cc68bc562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9034cfca0f02d21875d98300e719bb7067804052eff819420646e57810d2bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "44c334e278d211e949b19de68941e68a3d9df109146577b93ed7d30d1afbb8b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c0367106e6c79e6c886a53aa1f20966a1f0a151f00c6068794239abe8f1640f"
    sha256 cellar: :any_skip_relocation, catalina:       "fa466c5145f39e574d50ce79396780c4e35b7383a2beb2aeb8c3f4688531ea15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc83b03a66a2dca8aaa46e534d3640d96076b309ca354cbd3729bc58aef50a69"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/50a8c49e00c1eab3dae536acf81e956ec77372f3.tar.gz"
    sha256 "02ecfe918f564f1df7f73bc201ed62e3764fbb68d96a617d08cd64874a54741c"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    webassets_version = JSON.parse(curl_output)["sha"]
    assert_match webassets_version, resource("webassets").url
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
