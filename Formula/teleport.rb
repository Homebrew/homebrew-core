class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.0.3.tar.gz"
  sha256 "7dd44d92f2ca92e67722360f085c3e7b13b371c5784baecd5e8c2c33d1789bc4"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a498b87b13554da419d61e7b01ff5ebb5189961b58432b5a7250df699d9104"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "520e40952cafed72f2377f34fe392a6390179b13021b2552d7f2d61f27108113"
    sha256 cellar: :any_skip_relocation, monterey:       "40700eb3f7e2f6e3e466017add0af4c4218d25443faf4bbf154c07d29483387e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8060ca9c5984466b5d401259db22b23c936503d808d9662d056a9c22eaa158"
    sha256 cellar: :any_skip_relocation, catalina:       "52bf3f2092225092b02ba149712acc5d7a02162caab17205c1e0697a8aa6ecc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3667fcca539b5e551f3cbc3a24989cd9ea580042577654b5035a9fbf892c4667"
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
