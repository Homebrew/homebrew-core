class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.2.4.tar.gz"
  sha256 "d11856c09af0876c0f77ec9dca1080636b78bfe3157bf98035a3339ae7715486"
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
    sha256 cellar: :any,                 arm64_monterey: "2bf20e75d4968f6cd27365c99f91b4562cba72b17c1786479ec6ba74a23d5b88"
    sha256 cellar: :any,                 arm64_big_sur:  "407a18c3f8b2e0008d54cce706b5fb23c553ee3cd1f641d5e6de8d3c35020267"
    sha256 cellar: :any,                 monterey:       "30a111a7591bac47410d595d350d42b20eb7bf98ea3aec6f30253a4a129287d3"
    sha256 cellar: :any,                 big_sur:        "f6e4d3a7f20242e96658dde4effa268e6ba269744639e9fa0f917f7606596dfd"
    sha256 cellar: :any,                 catalina:       "57948467bea60c12e0dc39fd07d570a8b968977cbc27ea83de71d6252a2cb726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37606210ed3461f9978cf39a979296046b950fc8f939e8a1c909fd5db70caa7b"
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
    url "https://github.com/gravitational/webassets/archive/52c71e0c587647aa07a91599f1b9204d577de271.tar.gz"
    sha256 "e2c021a28b5befa00a162fb9baf0930c626d62a2549cbb9589244225da931850"
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
