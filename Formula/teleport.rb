class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.2.4.tar.gz"
  sha256 "3d73d415f9ac51790772513c26f271b897e3a8fbaad7eb98e01e9eabf2d2bee8"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00ed5ea0ecf859869bcf0dd29385d76b293f8a8591d167bf9fab92099579d561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c004a01b5a5bdb138de913a496f68ce216f76ec2d6821b868a9fe216358fc9e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5eab255fa64470bfc9cb1ba3401261c70c19290b105d7d9edc42e187657917"
    sha256 cellar: :any_skip_relocation, big_sur:        "83a4e624c0f2352c3a59c7a16dab0a7e59c4329152237aa7609b554cd110019e"
    sha256 cellar: :any_skip_relocation, catalina:       "50642109313380c0bd6a36e4f93a8f68a91e52c954d4072d7b880e5d19430d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196413563e8dd2af8bc1824ca94b680b2badc89fb2b746034fb406f39d124bbc"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/4c555ddd7f4e8c6d74dd1ac467db5d17ad5c4ecc.tar.gz"
    sha256 "00ba592b9a5f790e115d41a2a42127b178b75a362292b68b40577881a0984b19"
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
