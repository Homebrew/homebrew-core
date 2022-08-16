class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.1.3.tar.gz"
  sha256 "a1b707172699f98859506db10f81aa6f1022f22712a0bd69bd7367bfd42649aa"
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
    sha256 cellar: :any,                 arm64_monterey: "809691d453cd046fbbceea7ff441899a7567e5219c407b12b6f040c016fe1945"
    sha256 cellar: :any,                 arm64_big_sur:  "b81a7b4f51d520dab14bf8e6eb7ca0ff8c8d044b0805d661792390c33ccd4953"
    sha256 cellar: :any,                 monterey:       "730365c4353d15b0a2657b0bf94b271c87a0dec9adba2352c8a71f8f7fbf4d4a"
    sha256 cellar: :any,                 big_sur:        "15cbde0e7d861f7b23e02055d0d8af0af68afe39131257ca3de414516483a7b9"
    sha256 cellar: :any,                 catalina:       "5a712559613cc4e7c0e6bc701f6207b593289974313b87017bddb4007bbe31eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9450ad6f5fc7dd6f5dc50d42ee17680e51ed1d58b60786e130cdcf359af656"
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
    url "https://github.com/gravitational/webassets/archive/260ccff59f7e43ae2487433a40d4796868fc1b74.tar.gz"
    sha256 "41a1d0420eed16208bf5ba40a0960746ec6ce9629d49092b5f79dd867d4fbad5"
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
