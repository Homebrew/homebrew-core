class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.0.2.tar.gz"
  sha256 "c843ea347c79ff8707b65d578e38f0faae6e27c0c88cb66b3266f7272070c0a5"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21a441a0ab43effd522c6af0d5407496f31c56d6cb9fa36d3122f2a67b1efd6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f63f000f66e016fcb18db4bf91da8cbf673ca0e839a2a3f7ee5b7b80251be9a"
    sha256 cellar: :any_skip_relocation, monterey:       "afdf3db6551998f87b9a9a7904c0790d3986dce8d00113c2deca5f626deb9e8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec82fefa40954e558b746df9cd2275fd61c38113b187999367ff682abfb2014b"
    sha256 cellar: :any_skip_relocation, catalina:       "53afbfe07596291ba98a18e2acb9c59bfc113a8949ce27d1feac185a30790bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93169ed6c121f537b379e075dbf43edc2174a6eade96ba3dada855a5251ee54b"
  end

  depends_on "go" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/dae01015ca8e1310734e92faadd13e77844b7547.tar.gz"
    sha256 "9e15a80a055c0496bab93ca079abcd9ddff47eb43b4ebbb949d2797fcbbe3711"
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
