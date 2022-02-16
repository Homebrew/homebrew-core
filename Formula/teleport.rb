class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.3.0.tar.gz"
  sha256 "242ee0ed1ed01a328866956df12fd4567b070069cfaa605d4f59275acc390c31"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf75e1bfd7d0180431ce8a85e68eb46bb764be4376846ecd6b191e1b0aa87e90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d49d0cc6d1252da7dbd2d3b1d2559fc9ba3d0dfe550b960eebe39a274f6b0aa7"
    sha256 cellar: :any_skip_relocation, monterey:       "4087f28be13a07d55ad3c049de9b1b32ff2f89c6599e2f94e794e62edef7a69a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b948dbc61168428d59a349aa50adf37891250b90f8952dbf9ab73ffd81f6352"
    sha256 cellar: :any_skip_relocation, catalina:       "5f674d57db00b7f23d16a9c48dda1e7346e69ca8bc465fc52d9a15451b276140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97264e253d63412c79aa66de2ae89c890424bbe3cb79ff97652a1c6e64abd0b5"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/763ddfa16d2a2d8f4b1d24a7d6b9591c0677a20c.tar.gz"
    sha256 "033d77412d34c6cc72a1545c74cf3f56a32c6ef0dc2d6a64ea2dcf9de1c88eaf"
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
