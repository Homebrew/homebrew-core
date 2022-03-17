class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v9.0.1.tar.gz"
  sha256 "da01fd3e94a6c813bd1347db507c7757bae6d459b12bcf390fd8de0790a47151"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7148abc6a103f771cde47b38ad5991655b64bc20e3f4bdd6996abed41bd0d16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5b1fc6a67f283f89f0023392e58b8a7ab99f308924c91a86065accd546a8ce7"
    sha256 cellar: :any_skip_relocation, monterey:       "b0ef8e10f9103e0e825868a275f3db9aca82471e9434bc46d4337894c30c0225"
    sha256 cellar: :any_skip_relocation, big_sur:        "0daa0d2279f906376c2c1d68a26dc06a8780ef415e626cc177a31fdb2bbb8f57"
    sha256 cellar: :any_skip_relocation, catalina:       "84d2f937a2e6870117a5cb4bbcd0f969f47c6c9f303e728625d843a34ef7c03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cac0221a6ddc6c37ecc2ee564913298d687abc70332b24fb789239e8e4a4f09"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/db2dbcfaba9e35b00bdfda1415a42f086caf5b5e.tar.gz"
    sha256 "7e875ad361d3d75fd89d2738c5d97ec84c7e6c8d9a4221de03aded80fc3c8411"
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
